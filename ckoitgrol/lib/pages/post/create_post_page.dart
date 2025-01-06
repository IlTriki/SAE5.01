import 'package:camera/camera.dart';
import 'package:ckoitgrol/entities/user_post_entity.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:ckoitgrol/provider/user_data_provider.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late List<CameraDescription> _cameras;
  bool _isLoading = true;

  @override
  void initState() {
    _initCamera();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthService>().currentUser?.uid;
      if (userId != null) {
        context.read<UserDataProvider>().initializeUserData(userId);
      }
    });
  }

  void _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : RealTimeObjectDetection(
            cameras: _cameras,
          );
  }
}

class RealTimeObjectDetection extends StatefulWidget {
  final List<CameraDescription> cameras;

  const RealTimeObjectDetection({super.key, required this.cameras});

  @override
  State<RealTimeObjectDetection> createState() =>
      _RealTimeObjectDetectionState();
}

class _RealTimeObjectDetectionState extends State<RealTimeObjectDetection> {
  late CameraController _controller;
  bool isModelLoaded = false;
  List<dynamic>? recognitions;
  int imageHeight = 0;
  int imageWidth = 0;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _detectionPaused = false;
  List<dynamic>? savedRecognition;
  double? _selectedImageAspectRatio;
  bool _isDetecting = false;
  bool isCameraRotated = false;
  bool _isInferenceRunning = false;

  @override
  void initState() {
    super.initState();
    loadModel();
    initializeCamera(null);
  }

  @override
  void dispose() {
    if (_controller.value.isStreamingImages) {
      try {
        _controller.stopImageStream();
      } catch (e) {
        print('Error stopping image stream: $e');
      }
    }
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/models/detect.tflite',
      labels: 'assets/models/labelmap.txt',
    );
    setState(() {
      isModelLoaded = res != null;
    });
  }

  void toggleCamera() {
    setState(() {
      isCameraRotated = !isCameraRotated;
    });

    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    initializeCamera(newDescription);
  }

  void initializeCamera(CameraDescription? description) async {
    if (description == null) {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
    } else {
      _controller = CameraController(
        description,
        ResolutionPreset.high,
        enableAudio: false,
      );
    }

    try {
      await _controller.initialize();
      if (!mounted) return;

      _controller.startImageStream((CameraImage image) {
        if (isModelLoaded && !_detectionPaused && !_isDetecting) {
          runModel(image);
        }
      });

      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void updateImageDimensions(CameraImage image) {
    imageHeight = image.height;
    imageWidth = image.width;
  }

  void runModel(CameraImage image) async {
    if (image.planes.isEmpty || _detectionPaused || _isDetecting) return;

    _isDetecting = true;
    updateImageDimensions(image);

    try {
      var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        model: 'SSDMobileNet',
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResultsPerClass: 1,
        threshold: 0.4,
      );

      if (mounted) {
        setState(() {
          this.recognitions = recognitions;
        });
      }
    } catch (e) {
      print('Error during model inference: $e');
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> pickAndDetectImage() async {
    if (_isInferenceRunning || !isModelLoaded) {
      print('Inference is already running or model is not loaded.');
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('No image selected.');
      return;
    }

    print('Image selected: ${image.path}');

    // Pause the camera stream
    if (_controller.value.isStreamingImages) {
      await _controller.stopImageStream();
    }

    _imageFile = File(image.path);

    final decodedImage =
        await decodeImageFromList(_imageFile!.readAsBytesSync());
    _selectedImageAspectRatio = decodedImage.width / decodedImage.height;
    imageHeight = decodedImage.height;
    imageWidth = decodedImage.width;

    _isInferenceRunning = true; // Set the flag before starting inference

    try {
      var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,
      );

      print('Recognition results: $recognitions');

      setState(() {
        this.recognitions = recognitions;
        _detectionPaused = true; // Indicate that detection is paused
      });
    } catch (e) {
      print('Error during model inference: $e');
    } finally {
      _isInferenceRunning = false; // Reset the flag after inference
    }
  }

  Future<void> capturePhoto() async {
    if (!_controller.value.isInitialized) return;

    try {
      _detectionPaused = true;
      savedRecognition = recognitions; // Save current recognitions
      final image = await _controller.takePicture();
      _imageFile = File(image.path);

      setState(() {
        // Use the saved recognition
        recognitions = savedRecognition;
        // Update image dimensions
        ImageProvider provider = FileImage(_imageFile!);
        provider
            .resolve(const ImageConfiguration())
            .addListener(ImageStreamListener((ImageInfo info, bool _) {
          imageHeight = info.image.height;
          imageWidth = info.image.width;
        }));
      });
    } catch (e) {
      print('Error capturing photo: $e');
      _detectionPaused = false; // Reset if capture fails
    }
  }

  void validateImage() {
    if (_imageFile == null) return;
    createPost();
  }

  void resumeDetection() {
    if (!_controller.value.isStreamingImages) {
      _controller.startImageStream((CameraImage image) {
        if (isModelLoaded && !_detectionPaused && !_isDetecting) {
          runModel(image);
        }
      });
    }

    setState(() {
      _detectionPaused = false;
      _imageFile = null; // Clear the picked image
    });
  }

  Size getImageDimensions(BuildContext context) {
    if (_imageFile == null || _selectedImageAspectRatio == null) {
      return Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - 150,
      );
    }

    final availableHeight = MediaQuery.of(context).size.height - 150;
    final availableWidth = MediaQuery.of(context).size.width;

    double displayHeight = availableHeight;
    double displayWidth = availableHeight * _selectedImageAspectRatio!;

    if (displayWidth > availableWidth) {
      displayWidth = availableWidth;
      displayHeight = availableWidth / _selectedImageAspectRatio!;
    }

    return Size(displayWidth, displayHeight);
  }

  void createPost() async {
    if (_imageFile == null || recognitions == null || recognitions!.isEmpty) {
      return;
    }

    final currentUser =
        Provider.of<UserDataProvider>(context, listen: false).userData;
    if (currentUser == null) {
      print('User data is not available.');
      return;
    }

    final post = UserPostEntity(
      id: const Uuid().v4(),
      userId: currentUser.uid,
      username: currentUser.username!,
      title: 'GROLESQUE',
      text: 'TEMA MES GROL',
      imageUrl: _imageFile!.path,
      grolPercentage: recognitions![0]['confidenceInClass'],
      timestamp: DateTime.now(),
    );

    try {
      await Provider.of<PostsProvider>(context, listen: false)
          .addPost(post, _imageFile!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully!')),
      );
      // Clear the image and reset the state
      setState(() {
        _imageFile = null;
        recognitions = null;
        context.router.maybePop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    final imageDimensions = getImageDimensions(context);
    final screenH = MediaQuery.of(context).size.height - 150;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenW,
            height: screenH,
            child: Center(
              child: Container(
                width: imageDimensions.width,
                height: imageDimensions.height,
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    if (_imageFile == null)
                      Center(
                        child: CameraPreview(_controller),
                      )
                    else
                      Image.file(
                        _imageFile!,
                        fit: BoxFit.contain,
                        width: imageDimensions.width,
                        height: imageDimensions.height,
                      ),
                    if (recognitions != null)
                      BoundingBoxes(
                        recognitions: recognitions!,
                        previewH: _imageFile == null
                            ? screenH
                            : imageHeight.toDouble(),
                        previewW: _imageFile == null
                            ? screenW
                            : imageWidth.toDouble(),
                        screenH: imageDimensions.height,
                        screenW: imageDimensions.width,
                        isLive: _imageFile == null,
                      ),
                  ],
                ),
              ),
            ),
          ),
          ControlRow(
            isCameraRotated: isCameraRotated,
            toggleCamera: toggleCamera,
            pickAndDetectImage: pickAndDetectImage,
            capturePhoto: capturePhoto,
            cancelPhoto: resumeDetection,
            validateImage: validateImage,
            detectionPaused: _detectionPaused,
            imageFile: _imageFile,
          ),
        ],
      ),
    );
  }
}

class ControlRow extends StatelessWidget {
  final bool isCameraRotated;
  final VoidCallback toggleCamera;
  final VoidCallback pickAndDetectImage;
  final VoidCallback capturePhoto;
  final VoidCallback cancelPhoto;
  final VoidCallback validateImage;
  final bool detectionPaused;
  final File? imageFile;

  const ControlRow({
    super.key,
    required this.isCameraRotated,
    required this.toggleCamera,
    required this.pickAndDetectImage,
    required this.capturePhoto,
    required this.cancelPhoto,
    required this.validateImage,
    required this.detectionPaused,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: pickAndDetectImage,
          child: Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.photo_library, size: 25, color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: imageFile == null ? capturePhoto : cancelPhoto,
          child: Container(
            width: 50,
            height: 50,
            constraints: const BoxConstraints(
              minWidth: 50,
              minHeight: 50,
            ),
            decoration: BoxDecoration(
              color: imageFile == null ? Colors.white : Colors.black,
              shape: BoxShape.circle,
            ),
            child: imageFile == null
                ? null
                : const Icon(Icons.cancel_rounded,
                    size: 50, color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: imageFile == null ? toggleCamera : validateImage,
          child: Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: AnimatedRotation(
              turns: isCameraRotated ? 0.5 : 0,
              duration: const Duration(milliseconds: 500),
              child: Icon(
                  imageFile == null
                      ? Icons.cached_rounded
                      : Icons.check_rounded,
                  size: 25,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class BoundingBoxes extends StatelessWidget {
  final List<dynamic> recognitions;
  final double previewH;
  final double previewW;
  final double screenH;
  final double screenW;
  final bool isLive;

  const BoundingBoxes({
    super.key,
    required this.recognitions,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: recognitions.map((rec) {
        final double scaleW = screenW / previewW;
        final double scaleH = screenH / previewH;

        var x = isLive
            ? rec["rect"]["x"] * screenW
            : rec["rect"]["x"] * previewW * scaleW;
        var y = isLive
            ? rec["rect"]["y"] * screenH
            : rec["rect"]["y"] * previewH * scaleH;
        var w = isLive
            ? rec["rect"]["w"] * screenW
            : rec["rect"]["w"] * previewW * scaleW;
        var h = isLive
            ? rec["rect"]["h"] * screenH
            : rec["rect"]["h"] * previewH * scaleH;

        return Positioned(
          left: x,
          top: y,
          width: w,
          height: h,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 3,
              ),
            ),
            child: Text(
              "${rec["detectedClass"]} ${(rec["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                background: Paint()..color = Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
