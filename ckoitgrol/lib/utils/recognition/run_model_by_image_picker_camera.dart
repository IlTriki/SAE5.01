import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/config/object_detection.dart';
import 'package:ckoitgrol/route/router.dart';
import 'package:ckoitgrol/services/post/create_post_service.dart';
import 'package:ckoitgrol/utils/button/custom_button.dart';
import 'package:ckoitgrol/utils/recognition/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ckoitgrol/utils/recognition/custom_torch.dart';
import 'package:provider/provider.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class RunModelByImageCamera extends StatefulWidget {
  const RunModelByImageCamera({super.key});

  @override
  State<RunModelByImageCamera> createState() => RunModelByImageCameraState();
}

class RunModelByImageCameraState extends State<RunModelByImageCamera> {
  List<ResultObjectDetection>? objectDetectionResults;
  File? _image;
  ModelObjectDetection? _objectModel;
  bool _isLoading = false; // Add loading state
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    loadModel();
    runModels();
  }

  Future loadModel() async {
    String pathObjectDetectionModel = MODEL_PATH;
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
        pathObjectDetectionModel,
        LABELS_NUMBER,
        640,
        640,
        labelPath: LABELS_PATH,
      );
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future runModels() async {
    setState(() => _isLoading = true);

    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      setState(() => _isLoading = false);
      return;
    }

    File image = File(pickedImage.path);
    Uint8List imageBytes = await image.readAsBytes(); // Read bytes once

    // Run both models concurrently
    final results = await Future.wait([
      () async {
        try {
          return await _objectModel?.getImagePrediction(
            imageBytes,
            minimumScore: 0.6,
            iOUThreshold: 0.5,
          );
        } catch (e) {
          print("Error during object detection: $e");
          return null; // or handle the error as needed
        } finally {
          print("object detection done");
        }
      }(),
    ]);

    print("results $results");
    objectDetectionResults = results[0]
        ?.where((element) => element.className != 'no-shoes')
        .toList();

    setState(() {
      _image = image;
      _isLoading = false;
    });

    if (objectDetectionResults == null || objectDetectionResults!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No shoes detected, please try again !',
              style: TextStyle(color: Theme.of(context).colorScheme.surface)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 1),
          dismissDirection: DismissDirection.down,
          padding: const EdgeInsets.all(8),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              style: BorderStyle.solid,
            ),
          ),
        ),
      );
    }
  }

  void validateResults() async {
    if (objectDetectionResults != null &&
        objectDetectionResults!.isNotEmpty &&
        _image != null) {
      // take the fused image and save it to the create post service
      bytes = await controller.capture();
      if (bytes == null) {
        return;
      }
      // calculate highest score
      double highestScore = objectDetectionResults!
          .reduce((a, b) => a.score > b.score ? a : b)
          .score;
      context.read<CreatePostService>().imageFile = File.fromRawPath(bytes!);
      context.read<CreatePostService>().grolPercentage = highestScore;
      context.router.push(const SetPostDetailsRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _image == null || _isLoading
              ? placeholder(
                  context,
                  runModels,
                  _isLoading ? 'Loading...' : 'Take a photo to get started !',
                  Icons.camera_alt_outlined)
              : WidgetsToImage(
                  controller: controller,
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      width: MediaQuery.of(context).size.width - 20,
                      child: objectDetectionResults?.isNotEmpty ?? false
                          ? _objectModel!.renderBoxesOnImage(
                              _image!, objectDetectionResults ?? [])
                          : Center(
                              child: Image.file(_image!, fit: BoxFit.scaleDown),
                            ),
                    ),
                  ),
                ),
          if (_image != null) ...[
            CustomButton(
              onPressed: runModels,
              text: 'Retake Photo',
            ),
            CustomButton(
              onPressed: (objectDetectionResults != null &&
                      objectDetectionResults!.isNotEmpty)
                  ? validateResults
                  : null,
              text: 'Proceed',
              disabledColor: const Color(0xff171216),
            ),
          ],
        ],
      ),
    );
  }
}
