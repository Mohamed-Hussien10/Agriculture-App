import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A utility class for safe and flexible navigation operations.
class NavigationHelper {
  /// Checks if context is valid and mounted
  static bool _isContextValid(BuildContext? context) {
    return context != null && context.mounted;
  }

  /// 🟢 Pops the current route if possible, after the current frame.
  static void safePop(BuildContext context) {
    if (!_isContextValid(context)) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isContextValid(context)) return;

      try {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          debugPrint('NavigationHelper: Popped route');
        }
      } catch (e) {
        debugPrint('NavigationHelper: Error popping route - $e');
      }
    });
  }

  /// 🔄 Returns true if the current route can be popped.
  static bool canPop(BuildContext context) {
    return _isContextValid(context) && Navigator.canPop(context);
  }

  /// 🟢 Pushes a new route after the current frame.
  static void safePush<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    RouteFactory? routeFactory,
  }) {
    if (!_isContextValid(context)) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isContextValid(context)) return;

      try {
        Navigator.push(
          context,
          routeFactory?.call(RouteSettings()) as Route<T>? ??
              MaterialPageRoute<T>(builder: builder),
        );
        debugPrint('NavigationHelper: Pushed new route');
      } catch (e) {
        debugPrint('NavigationHelper: Error pushing route - $e');
      }
    });
  }

  /// 🟢 Pushes a new named route after the current frame.
  static void safePushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    if (!_isContextValid(context) || routeName.isEmpty) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isContextValid(context)) return;

      try {
        Navigator.pushNamed(context, routeName, arguments: arguments);
        debugPrint('NavigationHelper: Pushed named route: $routeName');
      } catch (e) {
        debugPrint(
          'NavigationHelper: Error pushing named route: $routeName - $e',
        );
      }
    });
  }

  /// 🔁 Pushes a named route and removes all previous routes after the current frame.
  static void safePushNamedAndRemoveUntil(
    BuildContext context,
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    if (!_isContextValid(context) || routeName.isEmpty) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isContextValid(context)) return;

      try {
        Navigator.pushNamedAndRemoveUntil(
          context,
          routeName,
          predicate,
          arguments: arguments,
        );
        debugPrint(
          'NavigationHelper: Pushed named route and removed until: $routeName',
        );
      } catch (e) {
        debugPrint(
          'NavigationHelper: Error pushing named route and remove until: $routeName - $e',
        );
      }
    });
  }

  /// 🔄 Replaces current route with a widget-based route after the current frame.
  static void safePushReplacement<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    RouteFactory? routeFactory,
  }) {
    if (!_isContextValid(context)) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isContextValid(context)) return;

      try {
        Navigator.pushReplacement(
          context,
          routeFactory?.call(RouteSettings()) as Route<T>? ??
              MaterialPageRoute<T>(builder: builder),
        );
        debugPrint('NavigationHelper: Replaced route');
      } catch (e) {
        debugPrint('NavigationHelper: Error replacing route - $e');
      }
    });
  }

  /// 🔄 Replaces current route with a named route after the current frame.
  static void safePushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    if (!_isContextValid(context) || routeName.isEmpty) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isContextValid(context)) return;

      try {
        Navigator.pushReplacementNamed(
          context,
          routeName,
          arguments: arguments,
        );
        debugPrint('NavigationHelper: Replaced named route: $routeName');
      } catch (e) {
        debugPrint(
          'NavigationHelper: Error replacing named route: $routeName - $e',
        );
      }
    });
  }

  /// ✅ IMMEDIATE push that returns a Future, used with `.then()` or `await`.
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    if (!_isContextValid(context) || routeName.isEmpty) {
      debugPrint(
        'NavigationHelper: Context invalid or route empty, skipping pushNamed',
      );
      return null;
    }

    try {
      final result = await Navigator.pushNamed<T>(
        context,
        routeName,
        arguments: arguments,
      );
      debugPrint(
        'NavigationHelper: Pushed named route (immediate): $routeName',
      );
      return result;
    } catch (e) {
      debugPrint(
        'NavigationHelper: Error pushing named route (immediate): $routeName - $e',
      );
      rethrow;
    }
  }

  /// ✅ IMMEDIATE push for a route with a builder that returns a Future.
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    RouteFactory? routeFactory,
  }) async {
    if (!_isContextValid(context)) {
      debugPrint('NavigationHelper: Context invalid, skipping push');
      return null;
    }

    try {
      final result = await Navigator.push<T>(
        context,
        routeFactory?.call(RouteSettings()) as Route<T>? ??
            MaterialPageRoute<T>(builder: builder),
      );
      debugPrint('NavigationHelper: Pushed route (immediate)');
      return result;
    } catch (e) {
      debugPrint('NavigationHelper: Error pushing route (immediate) - $e');
      rethrow;
    }
  }

  /// ✅ IMMEDIATE pushReplacementNamed that returns a Future.
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    TO? result,
    Object? arguments,
  }) async {
    if (!_isContextValid(context) || routeName.isEmpty) {
      debugPrint(
        'NavigationHelper: Context invalid or route empty, skipping pushReplacementNamed',
      );
      return null;
    }

    try {
      final newResult = await Navigator.pushReplacementNamed<T, TO>(
        context,
        routeName,
        result: result,
        arguments: arguments,
      );
      debugPrint(
        'NavigationHelper: Replaced named route (immediate): $routeName',
      );
      return newResult;
    } catch (e) {
      debugPrint(
        'NavigationHelper: Error replacing named route (immediate): $routeName - $e',
      );
      rethrow;
    }
  }
}
