import 'package:agriculture_app/Features/Alerts/presentation/view/widgets/alert_severity.dart';

class Alert {
  final String type;
  final AlertSeverity severity;
  final String description;
  final String environmentStatus;
  final String timestamp;

  Alert({
    required this.type,
    required this.severity,
    required this.description,
    required this.environmentStatus,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'severity': severity.index,
    'description': description,
    'environmentStatus': environmentStatus,
    'timestamp': timestamp,
  };

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    type: json['type'],
    severity: AlertSeverity.values[json['severity']],
    description: json['description'],
    environmentStatus: json['environmentStatus'],
    timestamp: json['timestamp'],
  );
}
