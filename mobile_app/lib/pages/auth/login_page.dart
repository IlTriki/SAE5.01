import 'package:ckoitgrol/pages/auth/forgot_password_page.dart';
import 'package:ckoitgrol/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ckoitgrol/pages/main_layout_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailOrUsernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginWithEmailOrUsername(BuildContext context) async {
    try {
      await _authService.signInWithEmailOrUsername(
        _emailOrUsernameController.text.trim(),
        _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainLayoutPage()));
    } catch (e) {
      final errorMessage = _authService.getErrorMessage(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void loginWithGoogle(BuildContext context) async {
    try {
      await _authService.singInWithGoogle();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainLayoutPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
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
                  TextField(
                    controller: _emailOrUsernameController,
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    decoration: InputDecoration(
                      hintText: Translate.of(context).loginOrEmail,
                      hintStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password field with visibility icon
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    decoration: InputDecoration(
                      hintText: Translate.of(context).password,
                      hintStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).canvasColor),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ForgottenPasswordPage()));
                      },
                      child: Text(
                        Translate.of(context).passwordForgotten,
                        style: TextStyle(color: Theme.of(context).canvasColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign In button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        loginWithEmailOrUsername(context);
                      },
                      child: Text(
                        Translate.of(context).signInButton,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
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
                        side: BorderSide(color: Theme.of(context).canvasColor),
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        loginWithGoogle(context);
                      },
                      label: Text(
                        Translate.of(context).signInGoogleButton,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context)
                              .outlinedButtonTheme
                              .style!
                              .textStyle!
                              .resolve({})!.color,
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
