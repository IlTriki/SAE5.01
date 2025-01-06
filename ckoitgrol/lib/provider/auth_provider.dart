import 'package:ckoitgrol/route/router.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ckoitgrol/services/router_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  final RouterService _router = RouterService();

  AuthProvider(this._authService) {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      print('Auth State Changed - User: ${user?.uid}');
      _user = user;
      _handleAuthStateChange(user);
      notifyListeners();
    });
  }

  void _handleAuthStateChange(User? user) {
    print('Handling Auth State Change - User: ${user?.uid}');
    if (user != null) {
      // User is signed in, navigate to main layout
      print('Attempting to navigate to MainLayout');
      _router.router.replace(const MainLayoutRoute());
    } else {
      // User is signed out, navigate to auth
      print('Attempting to navigate to Auth');
      _router.router.replace(const AuthRouter());
    }
  }

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    print('Starting sign in process');
    _isLoading = true;
    notifyListeners();

    try {
      final credentials =
          await _authService.signInWithEmailPassword(email, password);
      print('Sign in successful: ${credentials.user?.uid}');
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    print('Starting sign up process');
    _isLoading = true;
    notifyListeners();

    try {
      final credentials = await _authService.signUpWithEmailPassword(
        email,
        password,
        username,
      );
      print('Sign up successful: ${credentials.user?.uid}');
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    print('Starting Google sign in process');
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
      print('Google sign in successful');
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithApple() async {
    print('Starting Apple sign in process');
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signInWithApple();
      print('Apple sign in successful');
    } catch (e) {
      print('Apple sign in error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // notifyListeners();
  }
}
