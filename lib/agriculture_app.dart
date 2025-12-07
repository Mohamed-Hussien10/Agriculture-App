import 'package:agriculture_app/core/routing/app_routes.dart';
import 'package:agriculture_app/core/themes/app_colors.dart';
import 'package:agriculture_app/core/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agriculture_app/core/routing/app_router.dart';

/// Singleton MessageService for consistent snackbar handling
class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final List<String> _messageQueue = [];
  bool _isShowingMessage = false;

  void showMessage(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _messageQueue.add(message);
    _showNextMessage(duration);
  }

  void _showNextMessage(Duration duration) {
    if (_isShowingMessage || _messageQueue.isEmpty) return;

    _isShowingMessage = true;
    final message = _messageQueue.removeAt(0);

    scaffoldMessengerKey.currentState
        ?.showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            backgroundColor: AppColors.primary,
            duration: duration,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        )
        .closed
        .then((_) {
          _isShowingMessage = false;
          _showNextMessage(duration);
        });
  }

  void clearMessages() {
    _messageQueue.clear();
    scaffoldMessengerKey.currentState?.clearSnackBars();
    _isShowingMessage = false;
  }
}

/// Custom ScrollBehavior to support mouse, touch, and trackpad devices
class AdaptiveScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class AgricultureApp extends StatelessWidget {
  final AppRouter appRouter;
  final SharedPreferences prefs;

  const AgricultureApp({
    super.key,
    required this.appRouter,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final isDesktop = constraints.maxWidth >= 1024;
            final isWindows = defaultTargetPlatform == TargetPlatform.windows;
            final isLandscape = orientation == Orientation.landscape;

            // Responsive design parameters
            final designSize = _getDesignSize(
              isDesktop,
              isTablet,
              isWindows,
              isLandscape,
            );
            final textScale = _getTextScale(isDesktop, isLandscape);

            return ScreenUtilInit(
              designSize: designSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder:
                  (_, __) => _buildMaterialApp(
                    context,
                    isDesktop,
                    isTablet,
                    isWindows,
                    isLandscape,
                    textScale,
                  ),
            );
          },
        );
      },
    );
  }

  Size _getDesignSize(
    bool isDesktop,
    bool isTablet,
    bool isWindows,
    bool isLandscape,
  ) {
    if (isWindows) return const Size(1366, 768);
    if (isDesktop) return const Size(1366, 768);
    if (isTablet) {
      return isLandscape ? const Size(1280, 800) : const Size(800, 1280);
    }
    return isLandscape ? const Size(812, 375) : const Size(375, 812);
  }

  double _getTextScale(bool isDesktop, bool isLandscape) {
    if (isDesktop) return 1.0;
    return isLandscape ? 0.9 : 1.0;
  }

  Widget _buildMaterialApp(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
    bool isWindows,
    bool isLandscape,
    double textScale,
  ) {
    return Builder(
      builder: (context) {
        return MaterialApp(
          title: 'Agriculture App',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: MessageService().scaffoldMessengerKey,
          navigatorKey: AppRouter.navigatorKey,
          theme: _buildAppTheme(
            context,
            isDesktop,
            isTablet,
            isWindows,
            isLandscape,
          ),
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: AppRoutes.mainNavigationScreen,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: AdaptiveScrollBehavior(),
              child: GestureDetector(
                onTap: () => Utils.closeKeyboard(context),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler:
                        isWindows
                            ? TextScaler.noScaling
                            : TextScaler.linear(textScale),
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            );
          },
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: const Locale('ar'),
        );
      },
    );
  }

  ThemeData _buildAppTheme(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
    bool isWindows,
    bool isLandscape,
  ) {
    final baseTheme = ThemeData.light();

    return baseTheme.copyWith(
      primaryColor: AppColors.primary,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withOpacity(0.3),
        selectionHandleColor: AppColors.primary,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontFamily: isWindows ? 'Segoe UI' : null,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme, isWindows, isLandscape),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.symmetric(
          horizontal: isLandscape ? 8.w : 12.w,
          vertical: 8.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: isLandscape ? 12.h : 16.h,
        ),
      ),
      visualDensity:
          isWindows
              ? VisualDensity.standard
              : VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }

  TextTheme _buildTextTheme(
    TextTheme baseTheme,
    bool isWindows,
    bool isLandscape,
  ) {
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(
        fontSize: isLandscape ? 24.sp : 28.sp,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        fontSize: isLandscape ? 20.sp : 24.sp,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        fontSize: isLandscape ? 14.sp : 16.sp,
        fontFamily: isWindows ? 'Segoe UI' : null,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        fontSize: isLandscape ? 13.sp : 15.sp,
        fontFamily: isWindows ? 'Segoe UI' : null,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        fontSize: isLandscape ? 14.sp : 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
