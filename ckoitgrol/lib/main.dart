import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:ckoitgrol/firebase_options.dart';
import 'package:ckoitgrol/config/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:ckoitgrol/services/firebase/firestore_service.dart';
import 'package:ckoitgrol/services/firebase/firestorage_service.dart';
import 'package:ckoitgrol/services/firebase/firebase_post_service.dart';
import 'package:ckoitgrol/services/router_service.dart';
import 'package:ckoitgrol/provider/auth_provider.dart';
import 'package:ckoitgrol/provider/user_data_provider.dart';
import 'package:ckoitgrol/provider/common_provider.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ckoitgrol/route/router.dart';
import 'package:dart_json_mapper_flutter/dart_json_mapper_flutter.dart'
    show flutterAdapter;

import 'main.mapper.g.dart' show initializeJsonMapper;

void main() async {
  initializeJsonMapper(adapters: [flutterAdapter]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<UserDataProvider>(
          create: (context) =>
              UserDataProvider(context.read<FirestoreService>()),
        ),
        ChangeNotifierProvider<CommonProvider>(
          create: (context) => CommonProvider(null),
        ),
        ChangeNotifierProvider(
          create: (context) => PostsProvider(FirebasePostService()),
        ),
      ],
      child: MainApp(themeMode: savedThemeMode),
    ),
  );
}

class MainApp extends StatelessWidget {
  final AdaptiveThemeMode? themeMode;
  final _appRouter = AppRouter();

  MainApp({super.key, required this.themeMode}) {
    RouterService().setRouter(_appRouter);
  }

  @override
  Widget build(BuildContext context) {
    final systemLocale = View.of(context).platformDispatcher.locale;

    final locale = Translate.supportedLocales.firstWhere(
        (existingLocale) =>
            systemLocale.languageCode == existingLocale.languageCode,
        orElse: () => Translate.supportedLocales.first);

    return AdaptiveTheme(
      light: MaterialTheme(context).light(),
      dark: MaterialTheme(context).dark(),
      initial: themeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => LayoutBuilder(
        builder: (context, constraints) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
            boldText: false,
          ),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: Translate.localizationsDelegates,
            supportedLocales: Translate.supportedLocales,
            locale: Provider.of<CommonProvider>(context, listen: true).locale ??
                locale,
            routerConfig: _appRouter.config(),
            theme: theme,
            darkTheme: darkTheme,
          ),
        ),
      ),
    );
  }
}
