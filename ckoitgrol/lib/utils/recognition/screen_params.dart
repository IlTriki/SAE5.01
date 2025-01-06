import 'dart:math';
import 'dart:ui';

/// Singleton to record size related data
class ScreenParams {
  static late Size screenSize;
  static late Size previewSize;

  static Size get screenPreviewSize {
    // Calculate preview size while maintaining aspect ratio
    double screenAspectRatio = screenSize.width / screenSize.height;
    double previewAspectRatio = previewSize.width / previewSize.height;

    if (screenAspectRatio < previewAspectRatio) {
      // Width constrained
      return Size(
        screenSize.width,
        screenSize.width / previewAspectRatio,
      );
    } else {
      // Height constrained
      return Size(
        screenSize.height * previewAspectRatio,
        screenSize.height,
      );
    }
  }
}
