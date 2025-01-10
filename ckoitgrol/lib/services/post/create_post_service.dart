import 'dart:io';

import 'package:flutter/material.dart';

class CreatePostService with ChangeNotifier {
  int? imageMethod;
  File? imageFile;
  String? description;
  String? title;
  double? grolPercentage;
  String? date;
  String? author;
  String? authorProfilePicture;

  void setImageMethod(int method) {
    imageMethod = method;
    notifyListeners();
  }

  void setImage(File image) {
    this.imageFile = image;
    notifyListeners();
  }

  void setDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setGrolPercentage(double grolPercentage) {
    this.grolPercentage = grolPercentage;
    notifyListeners();
  }

  void setDate(String date) {
    this.date = date;
    notifyListeners();
  }

  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  void setAuthorProfilePicture(String authorProfilePicture) {
    this.authorProfilePicture = authorProfilePicture;
    notifyListeners();
  }

  void reset({bool fromRoot = true, bool notify = true}) {
    if (fromRoot) {
      imageMethod = null;
    }
    imageFile = null;
    description = null;
    title = null;
    grolPercentage = null;
    date = null;
    if (notify) {
      notifyListeners();
    }
  }
}
