import 'package:flutter/material.dart';
import 'previous_alert_item.dart';

class PreviousAlertsSection extends StatelessWidget {
  const PreviousAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A3D38).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "التنبيهات السابقة",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0A3D38)),
          ),
          const SizedBox(height: 8),
          Text(
            "قائمة بالتنبيهات منخفضة الأولوية أو التي تم معالجتها مسبقًا",
            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          const PreviousAlertItem(
            title: "ارتفاع درجة الحرارة في الصوبة رقم 2",
            status: "تم المعالجة",
          ),
          const PreviousAlertItem(
            title: "توقف مؤقت في مستشعر الرطوبة",
            status: "تحت المتابعة",
          ),
        ],
      ),
    );
  }
}