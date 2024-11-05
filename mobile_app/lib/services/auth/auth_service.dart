import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Instance of Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Email Sign In
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      // sign user in
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Email or Username Sign In
  Future<UserCredential> signInWithEmailOrUsername(
      String emailOrUsername, String password) async {
    String email;

    // Check if the input is an email
    bool isEmail = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailOrUsername);

    if (isEmail) {
      email = emailOrUsername;
    } else {
      // If it's not an email, assume it's a username and look up the corresponding email
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('username', isEqualTo: emailOrUsername.toLowerCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that username.',
        );
      }

      email = query.docs.first.get('email');
    }

    // Now sign in with the email
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Email Sign Up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      // sign user up
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Google Sign In
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      return;
    }

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // create a new credential for user
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in with credential
    return await _firebaseAuth.signInWithCredential(credential);
  }

  // possible error messages
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'Exception: wrong-password':
        return 'Password incorrect. Please try again.';
      case 'Exception: user-not-found':
        return 'User not found. Please sing up.';
      case 'Exception: invalid-email':
        return 'Invalid email. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
