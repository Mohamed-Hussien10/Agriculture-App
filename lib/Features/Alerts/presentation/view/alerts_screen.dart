import 'package:agriculture_app/Features/Alerts/data/models/alert_model.dart';
import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/alert_card.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        List<Alert> alerts = [];
        if (state is DashboardAlertsUpdated) {
          alerts = state.alerts;
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0A3D38),
          body: SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      const Text(
                        'التنبيهات',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      // Two icons: refresh & clear
                      Row(
                        children: [
                          // Refresh icon
                          GestureDetector(
                            onTap: () {
                              // Call cubit to reload alerts
                              context.read<DashboardCubit>().loadSavedAlerts();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Clear icon
                          GestureDetector(
                            onTap: () {
                              context.read<DashboardCubit>().clearAlerts();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                      child:
                          alerts.isEmpty
                              ? SizedBox(
                                height: 300,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.notifications_off,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "لا توجد تنبيهات حالياً",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : Column(
                                children: [
                                  for (var alert in alerts) ...[
                                    AlertCard(
                                      type: alert.type,
                                      severity: alert.severity,
                                      timestamp: alert.timestamp,
                                      description: alert.description,
                                      environmentStatus:
                                          alert.environmentStatus,
                                      nextAction:
                                          "عرض التوصيات والإجراءات المطلوبة",
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ],
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
