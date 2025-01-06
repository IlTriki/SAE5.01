import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<dynamic> recognitions;
  final Size imageSize;
  final Size screenSize;

  BoundingBoxPainter({
    required this.recognitions,
    required this.imageSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = screenSize.width / imageSize.width;
    final double scaleY = screenSize.height / imageSize.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (var detection in recognitions) {
      final rect = Rect.fromLTWH(
        detection['rect']['x'] * scaleX,
        detection['rect']['y'] * scaleY,
        detection['rect']['w'] * scaleX,
        detection['rect']['h'] * scaleY,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
