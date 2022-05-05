import 'package:flutter/material.dart';

const List<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('vi'),
  // Locale('th'),
];

const List<AppLocale> appLocales = <AppLocale>[
  AppLocale.english,
  AppLocale.vietnamese,
  // AppLocale.Thai,
];

enum AppLocale { english, vietnamese }

class LocaleModel extends ChangeNotifier {
  AppLocale appLocale = AppLocale.vietnamese;
  Locale currentLocale = supportedLocales[1];

  void toggleLocale(AppLocale newAppLocale) {
    if (newAppLocale == appLocale) return;
    switch (newAppLocale) {
      case AppLocale.english:
        currentLocale = supportedLocales[0];
        break;
      case AppLocale.vietnamese:
        currentLocale = supportedLocales[1];
        break;
      // case AppLocale.Thai:
      //   currentLocale = supportedLocales[2];
      //   break;
    }
    appLocale = newAppLocale;
    notifyListeners();
  }
}
