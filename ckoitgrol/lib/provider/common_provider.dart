import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Provider class that will manage selected app language
class CommonProvider with ChangeNotifier {
  CommonProvider(Locale? locale) : _selectedLocale = locale {
    _loadSavedLocale();
  }

  Locale? _selectedLocale;
  static const String _localeKey = 'selected_locale';

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_localeKey);

    if (savedLanguageCode != null) {
      onChangeOfLanguage(Locale(savedLanguageCode));
    }
  }

  Future<void> onChangeOfLanguage(Locale? locale) async {
    if (locale != null &&
        locale.languageCode != _selectedLocale?.languageCode) {
      _selectedLocale = Translate.supportedLocales.firstWhere(
          (existingLocale) =>
              locale.languageCode == existingLocale.languageCode,
          orElse: () => Translate.supportedLocales.first);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, _selectedLocale!.languageCode);

      notifyListeners();
    }
  }

  Locale? get locale => _selectedLocale;
}
