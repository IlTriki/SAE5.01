import 'package:ckoitgrol/utils/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/route/router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Translate.of(context).authMainTitle,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontFamily: 'TheBomb',
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Image.asset('assets/images/logo.png', width: 300, height: 300),
            Column(
              children: [
                CustomButton(
                  text: Translate.of(context).signUpButton,
                  onPressed: () => context.router.push(const SignupRoute()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(Translate.of(context).alreadyHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => context.router.push(const LoginRoute()),
                      child: Text(
                        Translate.of(context).loginButton,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
