import 'dart:async';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'recognition.dart';
import 'screen_params.dart';
import 'box_widget.dart';
import 'stats_widget.dart';
import 'package:ckoitgrol/services/detector/detector_service.dart';

/// [DetectorWidget] sends each frame for inference
class DetectorWidget extends StatefulWidget {
  /// Constructor
  const DetectorWidget({super.key});

  @override
  State<DetectorWidget> createState() => _DetectorWidgetState();
}

class _DetectorWidgetState extends State<DetectorWidget>
    with WidgetsBindingObserver {
  /// List of available cameras
  late List<CameraDescription> cameras;

  /// Controller
  CameraController? _cameraController;

  // use only when initialized, so - not null
  get _controller => _cameraController;

  /// Object Detector is running on a background [Isolate]
  Detector? _detector;
  StreamSubscription? _subscription;

  /// Results to draw bounding boxes
  List<Recognition>? results;

  /// Realtime stats
  Map<String, String>? stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    try {
      // Initialize detector first
      _detector = await Detector.start();
      _subscription = _detector?.resultsStream.stream.listen((values) {
        if (mounted) {
          setState(() {
            results = values['recognitions'];
            stats = values['stats'];
          });
        }
      });

      // Then initialize camera
      await _initializeCamera();
    } catch (e) {
      print('Error in initialization: $e');
    }
  }

  /// Initializes the camera by setting [_cameraController]
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    // cameras[0] for back-camera
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller.initialize();

      if (mounted) {
        /// Set preview size as soon as camera is initialized
        ScreenParams.previewSize = _controller.value.previewSize!;

        setState(() {});

        // Start image stream only after everything is initialized
        await _controller.startImageStream(_onLatestImageAvailable);
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void _onLatestImageAvailable(CameraImage cameraImage) {
    if (_detector != null && mounted) {
      _detector?.processFrame(cameraImage);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await _stopCamera();
        break;
      case AppLifecycleState.resumed:
        await _initStateAsync();
        break;
      default:
    }
  }

  Future<void> _stopCamera() async {
    if (_cameraController?.value.isStreamingImages ?? false) {
      await _cameraController?.stopImageStream();
    }
    await _cameraController?.dispose();
    _cameraController = null;

    _detector?.stop();
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update screen size whenever build is called
    ScreenParams.screenSize = MediaQuery.of(context).size;

    // Return empty container while the camera is not initialized
    if (_cameraController == null || !_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    var aspect = 1 / _controller.value.aspectRatio;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspect,
          child: CameraPreview(_controller),
        ),
        // Stats
        _statsWidget(),
        // Bounding boxes
        AspectRatio(
          aspectRatio: aspect,
          child: _boundingBoxes(),
        ),
      ],
    );
  }

  Widget _statsWidget() => (stats != null)
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white.withAlpha(150),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: stats!.entries
                    .map((e) => StatsWidget(e.key, e.value))
                    .toList(),
              ),
            ),
          ),
        )
      : const SizedBox.shrink();

  /// Returns Stack of bounding boxes
  Widget _boundingBoxes() {
    print('results: $results');
    if (results == null) {
      print('results is null');
      return const SizedBox.shrink();
    }
    return Stack(
        children: results!.map((box) => BoxWidget(result: box)).toList());
  }
}
