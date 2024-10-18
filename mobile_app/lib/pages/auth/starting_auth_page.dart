import 'package:ckoitgrol/pages/auth/login_page.dart';
import 'package:ckoitgrol/pages/auth/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartingAuthPage extends StatefulWidget {
  const StartingAuthPage({super.key});

  @override
  State<StartingAuthPage> createState() => _StartingAuthPageState();
}

class _StartingAuthPageState extends State<StartingAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  Text(
                    "CKOITGROL",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32,
                      fontFamily: "TheBomb",
                    ),
                  ),
                  const Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: 250,
                    height: 250,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: const Size.fromHeight(60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                        },
                        child: Text(
                          Translate.of(context).getStarted,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .outlinedButtonTheme
                              .style!
                              .backgroundColor!
                              .resolve({}),
                          minimumSize: const Size.fromHeight(60),
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                        },
                        child: Text(
                          Translate.of(context).haveAccount,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
