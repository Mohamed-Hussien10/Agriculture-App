import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/detection_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agriculture_app/Features/Dashboard/data/services/live_detection_service.dart';
import 'live_detection_state.dart';

class LiveDetectionCubit extends Cubit<LiveDetectionState> {
  final LiveDetectionService service;
  StreamSubscription? _streamSubscription;
  bool _isActive = false;
  int _frameCount = 0;

  LiveDetectionCubit(this.service) : super(const LiveDetectionInitial());

  /// Start the live detection (connect to WebSocket and start camera)
  void startListening() async {
    debugPrint("🔄 Starting WebSocket listener...");
    emit(const LiveDetectionConnecting());

    _isActive = true;
    _frameCount = 0;
    await service.connect();

    // Cancel any existing subscription
    await _streamSubscription?.cancel();

    // Use a single subscription to avoid "Stream has already been listened to" error
    _streamSubscription = service.stream?.listen(
      (data) {
        // Skip processing if not active
        if (!_isActive) return;
        debugPrint("📥 Raw data from server: $data");

        try {
          // FastAPI returns JSON string
          final decoded = jsonDecode(data);

          // Check for error response
          if (decoded.containsKey("error")) {
            debugPrint("⚠️ Server error: ${decoded["error"]}");
            emit(LiveDetectionError(decoded["error"]));
            return;
          }

          if (decoded.containsKey("detections")) {
            final List detections = decoded["detections"];
            _frameCount = decoded["frame"] ?? 0;
            debugPrint(
              "✅ Frame $_frameCount - Detections received: ${detections.length}",
            );

            // The image sent is 720x480, so normalize coordinates to 0-1 range
            const double imageWidth = 720.0;
            const double imageHeight = 480.0;

            final List<Detection> detectionObjects =
                detections.map((d) {
                  // FastAPI response format:
                  // {"class_id": int, "class_name": string, "confidence": float, "bbox": {"x_min": float, "y_min": float, "x_max": float, "y_max": float}}
                  // Coordinates are in pixels for a 720x480 image
                  final bbox = d["bbox"] ?? {};
                  final double xMin = (bbox["x_min"] ?? 0).toDouble();
                  final double yMin = (bbox["y_min"] ?? 0).toDouble();
                  final double xMax = (bbox["x_max"] ?? 0).toDouble();
                  final double yMax = (bbox["y_max"] ?? 0).toDouble();

                  // Normalize to 0-1 range for the painter
                  final double x = xMin / imageWidth;
                  final double y = yMin / imageHeight;
                  final double w = (xMax - xMin) / imageWidth;
                  final double h = (yMax - yMin) / imageHeight;

                  final String label = d["class_name"] ?? "Unknown";
                  final double confidence = (d["confidence"] ?? 0).toDouble();

                  debugPrint(
                    "🎯 Detection - label: $label, confidence: $confidence, normalized rect: [$x, $y, $w, $h]",
                  );

                  return Detection(
                    rect: Rect.fromLTWH(x, y, w, h),
                    label: label,
                    confidence: confidence,
                    color: Colors.red,
                  );
                }).toList();

            emit(
              LiveDetectionActive(
                detections: detectionObjects,
                frameCount: _frameCount,
              ),
            );
          } else {
            debugPrint("⚠️ Server response does not contain 'detections'");
          }
        } catch (e) {
          debugPrint("❌ Error decoding server data: $e");
          emit(LiveDetectionError(e.toString()));
        }
      },
      onDone: () {
        debugPrint("🔌 WebSocket closed by server.");
        if (_isActive) {
          emit(const LiveDetectionStopped());
        }
      },
      onError: (error) {
        debugPrint("❌ WebSocket error: $error");
        emit(LiveDetectionError(error.toString()));
      },
    );
  }

  /// Send a frame to the server for detection
  void sendFrame(Uint8List bytes, double previewWidth, double previewHeight) {
    debugPrint(
      "📤 Sending frame of size: ${bytes.length} bytes | Preview: $previewWidth x $previewHeight",
    );

    // Update state to show processing
    final currentState = state;
    if (currentState is LiveDetectionActive) {
      emit(currentState.copyWith(isProcessing: true));
    }

    service.sendFrame(bytes, previewWidth, previewHeight);
  }

  /// Clear all detections (when camera stops)
  void clearDetections() {
    emit(const LiveDetectionStopped());
  }

  /// Close the WebSocket connection
  void closeWebSocket() {
    debugPrint("🔌 Closing WebSocket connection");
    _isActive = false;
    _streamSubscription?.cancel();
    _streamSubscription = null;
    service.dispose();
    emit(const LiveDetectionStopped());
  }

  /// Reset to initial state
  void reset() {
    closeWebSocket();
    emit(const LiveDetectionInitial());
  }

  @override
  Future<void> close() {
    debugPrint("🔒 Closing LiveDetectionCubit and disposing service");
    _isActive = false;
    _streamSubscription?.cancel();
    service.dispose();
    return super.close();
  }
}
