import 'package:agriculture_app/Features/Dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:agriculture_app/agriculture_app.dart';
import 'package:agriculture_app/core/helpers/app_localizations.dart';
import 'package:agriculture_app/core/routing/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();

  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
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
