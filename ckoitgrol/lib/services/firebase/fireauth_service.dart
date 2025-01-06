import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  // Instance of Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Get the auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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

      // update user data
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Email Sign Up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String username) async {
    try {
      // sign user up
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // update user data
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'username': username,
      });

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
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    // First check if the document exists and has these fields
    final docSnapshot = await _firestore
        .collection('users')
        .doc(userCredential.user?.uid)
        .get();

    final Map<String, dynamic> dataToSet = {};
    if (!docSnapshot.exists || !docSnapshot.data()!.containsKey('uid')) {
      dataToSet['uid'] = userCredential.user?.uid;
    }
    if (!docSnapshot.exists || !docSnapshot.data()!.containsKey('username')) {
      dataToSet['username'] = userCredential.user?.displayName;
    }

    // Only perform the write if there are fields to update
    if (dataToSet.isNotEmpty) {
      await _firestore.collection('users').doc(userCredential.user?.uid).set(
            dataToSet,
            SetOptions(merge: true),
          );
    }

    return userCredential;
  }

  // Apple Sign In
  signInWithApple() async {
    final AuthorizationCredentialAppleID? credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential == null) {
      return;
    }

    final OAuthCredential oauthCredential =
        OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(oauthCredential);

    // update/create user document
    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'uid': userCredential.user?.uid,
      'username': userCredential.user?.displayName,
    }, SetOptions(merge: true));

    return userCredential;
  }

  // possible error messages
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'Exception: wrong-password':
        return 'Password incorrect. Please try again.';
      case 'Exception: email-already-in-use':
        return 'Email already in use. Please sign in.';
      case 'Exception: weak-password':
        return 'Password must be at least 6 characters.';
      case 'Exception: user-not-found':
        return 'User not found. Please sign up.';
      case 'Exception: invalid-email':
        return 'Invalid email. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
