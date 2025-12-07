import 'package:agriculture_app/Features/Actions/presentation/view/actions_screen.dart';
import 'package:agriculture_app/Features/Alerts/presentation/view/alerts_screen.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/dashboard_screen.dart';
import 'package:agriculture_app/Features/Home/presentation/view/widgets/bottom_nav_item.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    AlertsScreen(),
    ActionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // MAIN BODY
      body: _screens[_currentIndex],

      // BOTTOM NAV
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 0),
              child: BottomNavItem(
                icon: Icons.dashboard,
                label: "Dashboard",
                isActive: _currentIndex == 0,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 1),
              child: BottomNavItem(
                icon: Icons.notifications,
                label: "Alerts",
                isActive: _currentIndex == 1,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 2),
              child: BottomNavItem(
                icon: Icons.bolt_rounded,
                label: "Actions",
                isActive: _currentIndex == 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
