import 'package:ckoitgrol/firebase_options.dart';
import 'package:ckoitgrol/pages/auth/starting_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:ckoitgrol/pages/main_layout_page.dart';
import 'package:ckoitgrol/route/auth_guard.dart';
import 'package:ckoitgrol/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (BuildContext context) {
          return checkIfLoggedIn()
              ? const MainLayoutPage()
              : const StartingAuthPage();
        },
      ),
      localizationsDelegates: Translate.localizationsDelegates,
      supportedLocales: Translate.supportedLocales,
    );
  }
}
