import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/chart_card.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/circular_sensor.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/solution_tab.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D38),
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              child: Column(
                children: [
                  // ==================== Custom AppBar ====================
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'FarmEye',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'حلول زراعية مستدامة',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 16),

                      // Circular Sensors
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          CircularSensor(value: '25°C', label: 'درجة الحرارة'),
                          CircularSensor(value: '60%', label: 'رطوبة التربة'),
                          CircularSensor(value: 'الطين', label: 'نوع التربة'),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),

                  // ==================== Main Card ====================
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Warning Alert
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'تنبيه: جفاف التربة! الري مطلوب فوراً لتجنب تأثير سلبي على المحصول',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Solution Tabs
                        Row(
                          children: const [
                            Expanded(
                              child: SolutionTab(
                                label: 'التحكم البيولوجي',
                                icon: Icons.eco,
                                isActive: true,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: SolutionTab(
                                label: 'الري الدقيق',
                                icon: Icons.water_drop,
                                isActive: false,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Charts Row
                        Row(
                          children: const [
                            Expanded(
                              child: ChartCard(
                                title: 'تركيبة أعلاف الحيوان',
                                trendColor: Color(0xFF81C784),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ChartCard(
                                title: 'إنتاجية المحصول',
                                trendColor: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
