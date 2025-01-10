import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/config/object_detection.dart';
import 'package:ckoitgrol/route/router.dart';
import 'package:ckoitgrol/services/post/create_post_service.dart';
import 'package:ckoitgrol/utils/image/image_utils.dart';
import 'package:ckoitgrol/utils/recognition/custom_torch.dart';
import 'package:ckoitgrol/utils/recognition/placeholder.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class RunModelByImage extends StatefulWidget {
  const RunModelByImage({super.key});

  @override
  State<RunModelByImage> createState() => RunModelByImageState();
}

class RunModelByImageState extends State<RunModelByImage> {
  late ModelObjectDetection _objectModel;
  String? textToShow;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objectDetectionResults = [];
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  //load your model
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
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Future<void> runObjectDetection() async {
    //pick a random image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File imageFile = File(image.path);
    Uint8List imageBytes = await imageFile.readAsBytes();

    objectDetectionResults = await _objectModel.getImagePrediction(
      imageBytes,
      minimumScore: 0.6,
      iOUThreshold: 0.5,
    );

    setState(() {
      //this.objectDetectionResults = objectDetectionResults;
      _image = File(image.path);
    });
  }

  Future<void> validateImage() async {
    if (objectDetectionResults.isNotEmpty && _image != null) {
      try {
        bytes = await controller.capture();
        if (bytes == null) return;

        // Create a temporary file and write the bytes to it
        final tempDir = await Directory.systemTemp.create();
        final tempFile = File('${tempDir.path}/temp_image.png');
        await tempFile.writeAsBytes(bytes!);

        double highestScore = objectDetectionResults
            .where((result) => result != null)
            .reduce((a, b) => a!.score > b!.score ? a : b)!
            .score;

        Size imageSize = await getImageSize(tempFile);

        context.read<CreatePostService>().imageFile = tempFile;
        context.read<CreatePostService>().grolPercentage = highestScore;
        context.router.push(const SetPostDetailsRoute());
      } catch (e) {
        print("Error during image validation: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _image == null
            ? placeholder(
                context,
                runObjectDetection,
                'Select an image to get started !',
                Icons.photo_library_outlined)
            : Align(
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return FutureBuilder<Size>(
                      future: getImageSize(_image!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox();
                        return SizedBox(
                          width: snapshot.data!.width,
                          height: snapshot.data!.height,
                          child: WidgetsToImage(
                            controller: controller,
                            child: objectDetectionResults.isNotEmpty
                                ? _objectModel.renderBoxesOnImage(
                                    _image!, objectDetectionResults)
                                : Image.file(_image!, fit: BoxFit.contain),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
        // for (var element in objectDetectionResults)
        //   Text("class: ${element?.className} score: ${element?.score}"),
        if (_image != null)
          Positioned(
            bottom: 10,
            child: _decisionRow(),
          ),
      ],
    );
  }

  Widget _decisionRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: runObjectDetection,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.photo_library,
                  size: 25, color: Theme.of(context).colorScheme.surface),
            ),
          ),
          GestureDetector(
            onTap: objectDetectionResults.isNotEmpty
                ? validateImage
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No shoes detected, please try again !',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface)),
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
                  },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: objectDetectionResults.isNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xff171216),
                shape: BoxShape.circle,
              ),
              child: Icon(
                  objectDetectionResults.isNotEmpty ? Icons.check : Icons.close,
                  size: 25,
                  color: objectDetectionResults.isNotEmpty
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
