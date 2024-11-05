import 'package:ckoitgrol/services/auth/auth_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ckoitgrol/routing/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final signInError = Rxn<String>();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  Future<void> signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      signInError.value = 'Email and password cannot be empty';
      return;
    }

    try {
      await _authService.signInWithEmailOrUsername(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Get.offAllNamed(Routes.MAIN);
      signInError.value = null;
    } catch (error) {
      if (error.toString().contains('user-not-found')) {
        signInError.value = 'User not found';
      } else {
        signInError.value = 'Unknown error, please try again later';
      }
    }
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
    Get.offAllNamed(Routes.MAIN);
  }
}
