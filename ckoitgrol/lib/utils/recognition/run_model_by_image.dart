import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class RunModelByImage extends StatefulWidget {
  const RunModelByImage({super.key});

  @override
  State<RunModelByImage> createState() => RunModelByImageState();
}

class RunModelByImageState extends State<RunModelByImage> {
  late ModelObjectDetection _objectModel;
  String? textToShow;
  List? _prediction;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  //load your model
  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/best.torchscript";
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
        pathObjectDetectionModel,
        3,
        640,
        640,
        labelPath: "assets/labels/labels.txt",
      );
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Future runObjectDetection() async {
    //pick a random image

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Stopwatch stopwatch = Stopwatch()..start();
    objDetect = await _objectModel.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        iOUThreshold: 0.3);
    textToShow = inferenceTimeAsString(stopwatch);
    print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');

    for (var element in objDetect) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width == null ? 0 : element!.rect.width,
          "height": element?.rect.height == null ? 0 : element!.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }
    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  String inferenceTimeAsString(Stopwatch stopwatch) =>
      "Inference Took ${stopwatch.elapsed.inMilliseconds} ms";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Run model with Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: objDetect.isNotEmpty
                  ? _image == null
                      ? const Text('No image selected.')
                      : _objectModel.renderBoxesOnImage(_image!, objDetect)
                  : _image == null
                      ? const Text('No image selected.')
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Image.file(_image!, fit: BoxFit.scaleDown),
                        ),
            ),
            Center(
              child: Visibility(
                visible: textToShow != null,
                child: Text(
                  "$textToShow",
                  maxLines: 3,
                ),
              ),
            ),
            for (var element in objDetect)
              Text("class: ${element?.className} score: ${element?.score}"),
            TextButton(
              onPressed: runObjectDetection,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run object detection with labels",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
