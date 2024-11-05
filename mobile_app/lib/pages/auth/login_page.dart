import 'package:ckoitgrol/routing/app_pages.dart';
import 'package:ckoitgrol/utils/buttons/text_arrow_button.dart';
import 'package:ckoitgrol/utils/forms/text_field.dart';
import 'package:ckoitgrol/utils/text/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ckoitgrol/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sign In with Username or Email modal
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      Translate.of(context).welcomeBack,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Username or Email field
                  CustomAuthTextField(
                    controller: controller.emailController,
                    hintText: Translate.of(context).loginOrEmail,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => CustomAuthTextField(
                        icon: Icons.visibility_off,
                        controller: controller.passwordController,
                        hintText: Translate.of(context).password,
                        obscureText: controller.isPasswordHidden.value,
                        onPressedIcon: Icons.visibility,
                        onPressedIconFunction:
                            controller.togglePasswordVisibility,
                      )),
                  const SizedBox(height: 8),
                  Obx(() => controller.signInError.value != null
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.signInError.value!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        )
                      : Container()),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.FORGOT_PASSWORD);
                      },
                      child: Text(
                        Translate.of(context).passwordForgotten,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign In button
                  TextArrowButton(
                      text: Translate.of(context).signInButton.toCapitalized(),
                      onPressed: controller.signIn)
                ],
              ),
              // Google Sign In button
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: SvgPicture.asset(
                        'assets/images/google.svg',
                        width: 24,
                        height: 24,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(),
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        controller.signInWithGoogle();
                      },
                      label: Text(
                        Translate.of(context).signInGoogleButton,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
