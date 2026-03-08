import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final List<String> apiUrls = [
    "http://10.152.177.107:5084/api/sensor",
    "http://10.152.177.108:5084/api/sensor",
  ];

  bool isConnected = false;

  // =========================
  // Fetch Sensor Data
  // =========================
  Future<Map<String, dynamic>> getSensorData() async {
    for (String url in apiUrls) {
      try {
        print('[Service] 🌐 Trying: $url');

        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 3));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final mappedData = {
            'temperature': data['temperature'],
            'humidity': data['humidity'],
            'motion': data['motion'],
            'soil': data['soil'],
          };

          isConnected = true;

          print('[Service] ✅ Connected to $url');
          print('[Service] 🌱 Sensor Data: $mappedData');

          return mappedData;
        }
      } catch (e) {
        print('[Service] ❌ Failed to connect to $url');
      }
    }

    isConnected = false;
    throw Exception("All sensor servers are unreachable");
  }
}
