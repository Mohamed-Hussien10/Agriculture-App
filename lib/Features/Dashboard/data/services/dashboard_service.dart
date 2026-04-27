import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final String apiUrl = "http://agriculturewsserver.runasp.net/api/sensor";

  Timer? _timer;
  bool isConnected = false;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  // =========================
  // Start Polling (instead of WebSocket)
  // =========================
  void connect() {
    isConnected = true;

    print('[API] ✅ Started polling...');

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchData();
    });
  }

  // =========================
  // Fetch Data
  // =========================
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final mappedData = {
          'temperature': data['temperature'],
          'humidity': data['humidity'],
          'motion': data['motion'],
          'soil': data['soil'],
        };

        print('[API] 🌱 $mappedData');

        _controller.add(mappedData);
      } else {
        print('[API] ❌ Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('[API] ❌ Error: $e');
    }
  }

  // =========================
  // Stop Polling
  // =========================
  void disconnect() {
    _timer?.cancel();
    isConnected = false;

    print('[API] 🔌 Stopped polling');
  }

  // =========================
  // Dispose
  // =========================
  void dispose() {
    disconnect();
    _controller.close();
  }
}
