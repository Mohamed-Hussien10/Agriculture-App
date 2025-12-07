import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/alert_card.dart';
import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/alert_severity.dart';
import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/previous_alerts_section.dart';
import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D38),
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Alerts List
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                  child: Column(
                    children: const [
                      AlertCard(
                        type: "نشاط مرتفع غير طبيعي",
                        severity: AlertSeverity.critical,
                        timestamp: "03:15 ص",
                        description:
                            "تم رصد نشاط مرتفع جدًا (70%) في الصوبة الزراعية رقم 1",
                        environmentStatus:
                            "درجة الحرارة: 30 م° | الرطوبة: 78% (ظروف طبيعية)",
                        nextAction: "عرض التوصيات والإجراءات المطلوبة",
                      ),
                      SizedBox(height: 16),
                      AlertCard(
                        type: "تنبيه بدرجة الحرارة",
                        severity: AlertSeverity.warning,
                        timestamp: "02:45 ص",
                        description:
                            "ارتفاع درجة الحرارة في الصوبة رقم 2 (32 م°) - تم المعالجة",
                        environmentStatus: "الرطوبة: 65% (ظروف مثالية)",
                        nextAction: "مراجعة التوصيات",
                      ),
                      SizedBox(height: 16),
                      AlertCard(
                        type: "مستشعر الرطوبة",
                        severity: AlertSeverity.info,
                        timestamp: "01:30 ص",
                        description:
                            "توقف مؤقت في مستشعر الرطوبة - يُرجى الانتباه",
                        environmentStatus: "درجة الحرارة: 28 م° (مستقرة)",
                        nextAction: "فحص حالة المستشعر",
                      ),
                      SizedBox(height: 32),
                      PreviousAlertsSection(),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
