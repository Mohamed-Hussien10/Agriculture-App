import 'package:agriculture_app/Features/Actions/presentation/view/actions_screen.dart';
import 'package:agriculture_app/Features/Alerts/presentation/view/alerts_screen.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/dashboard_screen.dart';
import 'package:agriculture_app/Features/Home/presentation/view/main_navigation_screen.dart';
import 'package:agriculture_app/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static BuildContext? currentContext = navigatorKey.currentContext;

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case AppRoutes.alertsScreen:
        return MaterialPageRoute(builder: (_) => AlertsScreen());
      case AppRoutes.actionsScreen:
        return MaterialPageRoute(builder: (_) => ActionsScreen());
      case AppRoutes.mainNavigationScreen:
        return MaterialPageRoute(builder: (_) => MainNavigationScreen());

      // Define other routes here
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
