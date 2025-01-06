import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ckoitgrol/utils/button/custom_button.dart';
import 'package:ckoitgrol/utils/auth/auth_textfield.dart';
import 'package:ckoitgrol/utils/auth/alt_auth_button.dart';
import 'package:ckoitgrol/route/router.dart';
import 'package:ckoitgrol/provider/auth_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final errorMessage = ValueNotifier<String?>(null);
  final List<String> imgUrls = [
    'assets/images/icons/apple.svg',
    'assets/images/icons/google.svg',
  ];

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool emailIsValid(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool passwordsMatch() {
    return passwordController.text == confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        Translate.of(context).signupTitle,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            AuthTextField(
                              hintText: Translate.of(context).usernameHint,
                              controller: usernameController,
                            ),
                            const SizedBox(height: 15),
                            AuthTextField(
                              hintText: Translate.of(context).emailHint,
                              controller: emailController,
                            ),
                            const SizedBox(height: 15),
                            AuthTextField(
                              hintText: Translate.of(context).passwordHint,
                              controller: passwordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 15),
                            AuthTextField(
                              hintText:
                                  Translate.of(context).confirmPasswordHint,
                              controller: confirmPasswordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 10),
                            ValueListenableBuilder<String?>(
                              valueListenable: errorMessage,
                              builder: (context, error, _) => error != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        error,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            CustomButton(
                              text: Translate.of(context).signUpButton,
                              onPressed: usernameController.text.isNotEmpty &&
                                      emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty &&
                                      confirmPasswordController
                                          .text.isNotEmpty &&
                                      emailIsValid(emailController.text) &&
                                      passwordsMatch()
                                  ? () {
                                      final authProvider =
                                          context.read<AuthProvider>();
                                      authProvider
                                          .signUp(
                                        emailController.text,
                                        passwordController.text,
                                        usernameController.text,
                                      )
                                          .catchError((e) {
                                        errorMessage.value = AuthService()
                                            .getErrorMessage(e.toString());
                                      });
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                        Translate.of(context).orSignUpWith),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AltAuthButton(
                                  imgUrl: imgUrls[0],
                                  onPressed: () {
                                    final authProvider =
                                        context.read<AuthProvider>();
                                    authProvider
                                        .signInWithApple()
                                        .catchError((e) {
                                      errorMessage.value = AuthService()
                                          .getErrorMessage(e.toString());
                                    });
                                  },
                                ),
                                AltAuthButton(
                                  imgUrl: imgUrls[1],
                                  onPressed: () {
                                    final authProvider =
                                        context.read<AuthProvider>();
                                    authProvider
                                        .signInWithGoogle()
                                        .catchError((e) {
                                      errorMessage.value = AuthService()
                                          .getErrorMessage(e.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Translate.of(context).alreadyHaveAccount,
                              style: Theme.of(context).textTheme.bodyMedium),
                          TextButton(
                            onPressed: () {
                              context.router.replace(const LoginRoute());
                            },
                            child: Text(
                              Translate.of(context).loginButton,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
