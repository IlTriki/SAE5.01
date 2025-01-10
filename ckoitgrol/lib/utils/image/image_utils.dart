import 'dart:io';

import 'package:flutter/material.dart';

Future<Size> getImageSize(File imageFile) async {
  final image = await decodeImageFromList(await imageFile.readAsBytes());
  return Size(image.width.toDouble(), image.height.toDouble());
}
