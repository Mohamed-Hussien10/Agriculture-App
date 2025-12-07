import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../routing/app_router.dart';

class AppLocalizations {
  static const Locale english = Locale('en'); // English
  static const Locale french = Locale('fr'); // French
  static const Locale arabic = Locale('ar'); // Arabic

  static const List<Locale> supportedLocales = [english, french, arabic];

  static const String translationsPath = 'assets/translations';

  static bool get isEnglish => AppRouter.currentContext!.locale == english;

  static Future<void> changeLocaleAndRecallData() async {
    final currentLocale = AppRouter.currentContext!.locale;
    Locale newLocale;
    if (currentLocale == english) {
      newLocale = french;
    } else if (currentLocale == french) {
      newLocale = arabic;
    } else {
      newLocale = english;
    }
    await AppRouter.currentContext!.setLocale(newLocale);
    recallData();
  }

  static void recallData() {
    // Add your code here.
  }

  static void resetData() {
    // Add your code here.
  }
}
