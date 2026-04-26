import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class DashboardService {
  final String wsUrl = "ws://agriculturewsserver.runasp.net/ws";

  WebSocketChannel? _channel;

  bool isConnected = false;

  // Stream Controller (expose data to Cubit)
  final _controller = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  // =========================
  // Connect
  // =========================
  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      isConnected = true;

      print('[WS] ✅ Connected');

      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);

            final mappedData = {
              'temperature': data['temperature'],
              'humidity': data['humidity'],
              'motion': data['motion'],
              'soil': data['soil'],
            };

            print('[WS] 🌱 $mappedData');

            // Push to stream
            _controller.add(mappedData);
          } catch (e) {
            print('[WS] ❌ Parse error: $e');
          }
        },
        onError: (error) {
          print('[WS] ❌ Error: $error');
          isConnected = false;
        },
        onDone: () {
          print('[WS] 🔌 Disconnected');
          isConnected = false;
        },
      );
    } catch (e) {
      print('[WS] ❌ Connection failed: $e');
      isConnected = false;
    }
  }

  // =========================
  // Disconnect
  // =========================
  void disconnect() {
    _channel?.sink.close();
    isConnected = false;
  }
}
