import 'dart:typed_data';
import 'package:web_socket_channel/io.dart';

class LiveDetectionService {
  // FastAPI WebSocket endpoint - update this to your server URL
  // Default points to local server
  final String baseUrl;
  final double confThreshold;

  IOWebSocketChannel? _channel;
  bool _connected = false;
  final List<Uint8List> _pendingFrames = [];

  LiveDetectionService({
    this.baseUrl =
        "https://hazemgamal223311--pest-detector-fastapi-app.modal.run",
    this.confThreshold = 0.35,
  });

  String get url {
    // Convert https:// to wss:// for WebSocket
    String wsUrl = baseUrl.replaceFirst('https://', 'wss://');
    wsUrl = wsUrl.replaceFirst('http://', 'ws://');
    return "$wsUrl/ws/detect?conf_threshold=$confThreshold";
  }

  /// Connect to WebSocket server
  Future<void> connect() async {
    try {
      print("🌐 Connecting to WebSocket: $url");
      _channel = IOWebSocketChannel.connect(url);

      // Wait for connection to be ready
      await _channel!.ready;

      _connected = true;
      print("✅ Connected to WebSocket");
      _sendPendingFrames();
    } catch (e) {
      _connected = false;
      print("❌ Failed to connect: $e");
    }
  }

  /// Expose the WebSocket stream (only after connection is ready)
  Stream? get stream => _channel?.stream;

  /// Send a single frame
  void sendFrame(Uint8List bytes, double previewWidth, double previewHeight) {
    if (!_connected) {
      _pendingFrames.add(bytes);
      print(
        "⏳ WebSocket not connected, frame queued (queue size: ${_pendingFrames.length}) | Preview: $previewWidth x $previewHeight",
      );
      return;
    }

    _sendBinary(bytes, previewWidth, previewHeight);
  }

  /// Send frames stored in the queue
  void _sendPendingFrames() {
    if (!_connected) return;
    while (_pendingFrames.isNotEmpty) {
      final pending = _pendingFrames.removeAt(0);
      _sendBinary(pending, 0, 0); // Preview size unknown for queued frames
    }
  }

  /// Send raw binary image data to FastAPI server
  void _sendBinary(Uint8List bytes, double previewWidth, double previewHeight) {
    // Image is already JPEG from camera converter, send directly
    try {
      // Send raw binary data (FastAPI expects bytes, not JSON)
      _channel?.sink.add(bytes);
      print(
        "📤 Sent frame of size: ${bytes.length} bytes | Preview: ${previewWidth.toStringAsFixed(1)} x ${previewHeight.toStringAsFixed(1)}",
      );
    } catch (e) {
      print("❌ Failed to send frame: $e");
      _pendingFrames.add(bytes); // requeue
    }
  }

  /// Check if connected
  bool get isConnected => _connected;

  /// Close the connection
  void dispose() {
    try {
      _channel?.sink.close();
      _connected = false;
      print("🔌 WebSocket closed");
    } catch (e) {
      print("❌ Error closing WebSocket: $e");
    }
  }
}
