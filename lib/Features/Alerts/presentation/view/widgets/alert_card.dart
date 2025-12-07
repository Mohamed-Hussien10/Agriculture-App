import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/alert_severity.dart';
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String type;
  final AlertSeverity severity;
  final String timestamp;
  final String description;
  final String environmentStatus;
  final String nextAction;

  const AlertCard({
    super.key,
    required this.type,
    required this.severity,
    required this.timestamp,
    required this.description,
    required this.environmentStatus,
    required this.nextAction,
  });

  Color get color {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFEF4444);
      case AlertSeverity.warning:
        return const Color(0xFFF59E0B);
      case AlertSeverity.info:
        return const Color(0xFF3B82F6);
    }
  }

  Color get bgColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFFFE5E5);
      case AlertSeverity.warning:
        return const Color(0xFFFFF5E1);
      case AlertSeverity.info:
        return const Color(0xFFE5F0FF);
    }
  }

  String get label {
    switch (severity) {
      case AlertSeverity.critical:
        return "حرج";
      case AlertSeverity.warning:
        return "تحذير";
      case AlertSeverity.info:
        return "معلومة";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.warning_rounded, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0A3D38),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timestamp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.6,
              color: Color(0xFF2D3748),
            ),
          ),

          const SizedBox(height: 12),
          _buildInfoRow("حالة البيئة", environmentStatus),
          const SizedBox(height: 10),
          _buildInfoRow("الإجراء التالي", nextAction, isAction: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isAction = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.5,
            color: Color(0xFF4B5563),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color:
                  isAction ? const Color(0xFF0A3D38) : const Color(0xFF4B5563),
              fontWeight: isAction ? FontWeight.w600 : null,
            ),
          ),
        ),
      ],
    );
  }
}
