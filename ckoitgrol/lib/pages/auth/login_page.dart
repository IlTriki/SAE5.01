import 'package:ckoitgrol/provider/auth_provider.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ckoitgrol/utils/button/custom_button.dart';
import 'package:ckoitgrol/utils/auth/auth_textfield.dart';
import 'package:ckoitgrol/utils/auth/alt_auth_button.dart';
import 'package:ckoitgrol/route/router.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final errorMessage = ValueNotifier<String?>(null);
  final List<String> imgUrls = [
    'assets/images/icons/apple.svg',
    'assets/images/icons/google.svg',
  ];

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool emailIsValid(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
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
                        Translate.of(context).loginTitle,
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
                              hintText: Translate.of(context).emailHint,
                              controller: emailController,
                            ),
                            const SizedBox(height: 15),
                            AuthTextField(
                              hintText: Translate.of(context).passwordHint,
                              controller: passwordController,
                              obscureText: true,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  context.router
                                      .push(const ForgotPasswordRoute());
                                },
                                child: Text(
                                    Translate.of(context).forgotPasswordTitle,
                                    textAlign: TextAlign.end),
                              ),
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
                              text: Translate.of(context).loginButton,
                              onPressed: emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty &&
                                      emailIsValid(emailController.text)
                                  ? () {
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      authProvider
                                          .signIn(
                                        emailController.text,
                                        passwordController.text,
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
                                    child:
                                        Text(Translate.of(context).orLoginWith),
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
                          Text(Translate.of(context).dontHaveAccount,
                              style: Theme.of(context).textTheme.bodyMedium),
                          TextButton(
                            onPressed: () {
                              context.router.replace(const SignupRoute());
                            },
                            child: Text(
                              Translate.of(context).signUpButton,
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
