import 'package:agriculture_app/agriculture_app.dart';
import 'package:agriculture_app/core/helpers/app_localizations.dart';
import 'package:agriculture_app/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: true,
      builder:
          (context) => ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: EasyLocalization(
              supportedLocales: AppLocalizations.supportedLocales,
              path: AppLocalizations.translationsPath,
              fallbackLocale: AppLocalizations.english,
              startLocale: AppLocalizations.english,
              child: AgricultureApp(appRouter: AppRouter(), prefs: prefs),
            ),
          ),
    ),
  );
}
