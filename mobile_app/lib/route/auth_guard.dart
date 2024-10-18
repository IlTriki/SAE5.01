import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

bool checkIfLoggedIn() {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}
