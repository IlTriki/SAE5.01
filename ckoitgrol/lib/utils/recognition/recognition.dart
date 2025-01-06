import 'package:flutter/cupertino.dart';
import 'screen_params.dart';

/// Represents the recognition output from the model
class Recognition {
  /// Index of the result
  final int _id;

  /// Label of the result
  final String _label;

  /// Confidence [0.0, 1.0]
  final double _score;

  /// Location of bounding box rect
  ///
  /// The rectangle corresponds to the raw input image
  /// passed for inference
  final Rect _location;

  Recognition(this._id, this._label, this._score, this._location);

  int get id => _id;

  String get label => _label;

  double get score => _score;

  Rect get location => _location;

  /// Returns bounding box rectangle corresponding to the
  /// displayed image on screen
  ///
  /// This is the actual location where rectangle is rendered on
  /// the screen
  Rect get renderLocation {
    // Get screen preview size
    final double previewWidth = ScreenParams.screenPreviewSize.width;
    final double previewHeight = ScreenParams.screenPreviewSize.height;

    // Calculate scaling factors
    final double scaleX = previewWidth / ScreenParams.previewSize.width;
    final double scaleY = previewHeight / ScreenParams.previewSize.height;

    // Scale the bounding box coordinates
    return Rect.fromLTWH(
      location.left * scaleX,
      location.top * scaleY,
      location.width * scaleX,
      location.height * scaleY,
    );
  }

  @override
  String toString() {
    return 'Recognition(id: $id, label: $label, score: $score, location: $location)';
  }
}
