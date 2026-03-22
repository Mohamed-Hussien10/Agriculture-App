import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/detection_painter.dart';

/// Base class for all live detection states
abstract class LiveDetectionState {
  const LiveDetectionState();
}

/// Initial state - camera not started
class LiveDetectionInitial extends LiveDetectionState {
  const LiveDetectionInitial();
}

/// Connecting to WebSocket server
class LiveDetectionConnecting extends LiveDetectionState {
  const LiveDetectionConnecting();
}

/// Camera is running and detecting pests
class LiveDetectionActive extends LiveDetectionState {
  final List<Detection> detections;
  final bool isProcessing;
  final int frameCount;

  const LiveDetectionActive({
    this.detections = const [],
    this.isProcessing = false,
    this.frameCount = 0,
  });

  LiveDetectionActive copyWith({
    List<Detection>? detections,
    bool? isProcessing,
    int? frameCount,
  }) {
    return LiveDetectionActive(
      detections: detections ?? this.detections,
      isProcessing: isProcessing ?? this.isProcessing,
      frameCount: frameCount ?? this.frameCount,
    );
  }

  /// Check if any pests are detected
  bool get hasPests => detections.isNotEmpty;

  /// Get the most confident detection
  Detection? get topDetection {
    if (detections.isEmpty) return null;
    return detections.reduce((a, b) => a.confidence > b.confidence ? a : b);
  }
}

/// Error state
class LiveDetectionError extends LiveDetectionState {
  final String message;

  const LiveDetectionError(this.message);
}

/// Camera stopped
class LiveDetectionStopped extends LiveDetectionState {
  const LiveDetectionStopped();
}
