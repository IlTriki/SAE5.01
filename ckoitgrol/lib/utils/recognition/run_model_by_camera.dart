import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/route/router.dart';

import 'package:ckoitgrol/services/post/create_post_service.dart';
import 'box_widget.dart';
import 'camera_view.dart';

class RunModelByCamera extends StatefulWidget {
  const RunModelByCamera({super.key});

  @override
  State<RunModelByCamera> createState() => RunModelByCameraState();
}

class RunModelByCameraState extends State<RunModelByCamera> {
  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;
  bool isCameraRotated = false;
  bool isImageCaptured = false;
  File? imageFile;
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;
  Image? capturedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: Column(
        children: [
          SizedBox(
            // minus app bar and bottom navigation bar
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                kToolbarHeight -
                100,
            width: MediaQuery.of(context).size.width,
            child: WidgetsToImage(
              controller: controller,
              child: Stack(
                children: <Widget>[
                  if (!isImageCaptured)
                    CameraView(resultsCallback,
                        isCameraRotated: isCameraRotated),
                  if (capturedImage != null && isImageCaptured) capturedImage!,
                  boundingBoxes2(results),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 25),
              GestureDetector(
                onTap: results != null
                    ? !isImageCaptured
                        ? capturePhoto
                        : cancelPhoto
                    : showSnackBar,
                child: Container(
                  width: 50,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 50,
                  ),
                  decoration: BoxDecoration(
                    color: !isImageCaptured ? Colors.white : Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: !isImageCaptured
                      ? null
                      : const Icon(Icons.cancel_rounded,
                          size: 50, color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: !isImageCaptured ? toggleCamera : validateImage,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      !isImageCaptured
                          ? Icons.cached_rounded
                          : Icons.check_rounded,
                      size: 25,
                      color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please wait for results before taking photo",
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

  /// Returns Stack of bounding boxes
  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e)).toList(),
    );
  }

  void resultsCallback(
      List<ResultObjectDetection> results, Duration inferenceTime) {
    if (!mounted || isImageCaptured) {
      return;
    }
    setState(() {
      this.results = results.where((e) => e.className != "no-shoes").toList();
      objectDetectionInferenceTime = inferenceTime;
    });
  }

  void capturePhoto() async {
    if (results == null || results!.isEmpty) {
      showSnackBar();
      return;
    }

    try {
      // Capture the current view including camera frame
      final bytes = await controller.capture();
      if (bytes == null) return;

      setState(() {
        capturedImage = Image.memory(bytes, fit: BoxFit.contain);
        isImageCaptured = true;
      });
    } catch (e) {
      print("Error capturing photo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error capturing image",
              style: TextStyle(color: Theme.of(context).colorScheme.surface)),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  void cancelPhoto() {
    setState(() {
      isImageCaptured = false;
      capturedImage = null;
    });
  }

  void toggleCamera() {
    print("toggleCamera");
    setState(() {
      isCameraRotated = !isCameraRotated;
      print("isCameraRotated: $isCameraRotated");
    });
  }

  void validateImage() async {
    if (results == null || results!.isEmpty || capturedImage == null) return;

    try {
      // Capture the final view with boxes
      final bytes = await controller.capture();
      if (bytes == null) return;

      // Create a temporary file and write the bytes to it
      final tempDir = await Directory.systemTemp.create();
      final tempFile = File('${tempDir.path}/temp_image.png');
      await tempFile.writeAsBytes(bytes);

      // Calculate highest detection score
      double highestScore =
          results!.reduce((a, b) => a.score > b.score ? a : b).score;

      // Update the CreatePostService
      context.read<CreatePostService>().setImage(tempFile);
      context.read<CreatePostService>().grolPercentage = highestScore;

      // Navigate to post details
      context.router.push(const SetPostDetailsRoute());
    } catch (e) {
      print("Error during image validation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving image",
              style: TextStyle(color: Theme.of(context).colorScheme.surface)),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }
}
