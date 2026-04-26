import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/detection_painter.dart';
import 'yuv_to_jpg_converter.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/manager/live_detection_cubit.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/manager/live_detection_state.dart';

class LiveDetectionSection extends StatefulWidget {
  const LiveDetectionSection({super.key});

  @override
  State<LiveDetectionSection> createState() => _LiveDetectionSectionState();
}

class _LiveDetectionSectionState extends State<LiveDetectionSection> {
  CameraController? controller;
  bool isProcessing = false;
  bool isLiveRunning = false;
  bool isInitializing = false; // Prevent concurrent initialization
  bool _isDisposed = false;
  double previewWidth = 0;
  double previewHeight = 0;

  @override
  void dispose() {
    _isDisposed = true;
    _stopCameraWithoutSetState();
    super.dispose();
  }

  Future<void> _stopCameraWithoutSetState() async {
    final localController = controller;
    controller = null;

    if (localController != null) {
      try {
        if (localController.value.isStreamingImages) {
          await localController.stopImageStream();
        }
        await localController.dispose();
      } catch (e) {
        debugPrint("Error stopping camera: $e");
      }
    }

    if (!_isDisposed && mounted) {
      try {
        context.read<LiveDetectionCubit>().clearDetections();
        context.read<LiveDetectionCubit>().closeWebSocket();
      } catch (e) {
        debugPrint("Error clearing detections: $e");
      }
    }
  }

  Future<void> startCamera() async {
    // Prevent multiple camera starts
    if (isInitializing ||
        _isDisposed ||
        (controller != null && controller!.value.isInitialized)) {
      debugPrint("Camera already running or initializing");
      return;
    }

    isInitializing = true;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty || _isDisposed) {
        debugPrint("No cameras available on this device.");
        return;
      }

      // Dispose existing controller if any
      if (controller != null) {
        await controller!.dispose();
        controller = null;
      }

      controller = CameraController(cameras.first, ResolutionPreset.medium);

      await controller!.initialize();
      previewWidth = controller!.value.previewSize?.width ?? 0;
      previewHeight = controller!.value.previewSize?.height ?? 0;

      await Future.delayed(const Duration(milliseconds: 200));

      // Check again if already streaming or disposed
      if (_isDisposed || !controller!.value.isInitialized) {
        debugPrint("Camera not initialized");
        return;
      }

      if (!mounted) return;

      setState(() {
        isLiveRunning = true;
      });

      // Start WebSocket connection after camera is ready
      context.read<LiveDetectionCubit>().startListening();

      controller!.startImageStream((CameraImage image) async {
        if (_isDisposed ||
            !isLiveRunning ||
            isProcessing ||
            controller == null ||
            !controller!.value.isInitialized)
          return;

        isProcessing = true;

        try {
          final jpegBytes = convertYUV420ToJPG(image);
          if (mounted && isLiveRunning && !_isDisposed) {
            context.read<LiveDetectionCubit>().sendFrame(
              jpegBytes,
              previewWidth,
              previewHeight,
            );
          }
        } catch (e) {
          debugPrint("Error processing frame: $e");
        } finally {
          isProcessing = false;
        }
      });
    } catch (e) {
      debugPrint("Error starting camera: $e");
    } finally {
      isInitializing = false;
    }
  }

  Future<void> stopCamera() async {
    if (!mounted) return;
    
    setState(() {
      isLiveRunning = false;
      isProcessing = false;
    });

    await _stopCameraWithoutSetState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bug_report_outlined,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "اكتشاف الآفات مباشرة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "تحليل آلي في الوقت الحقيقي",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  controller == null || !controller!.value.isInitialized
                      ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.videocam_outlined,
                                  size: 48,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: startCamera,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                icon: const Icon(Icons.play_arrow),
                                label: const Text(
                                  "ابدأ الكشف المباشر",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "استخدم الكاميرا للكشف عن الآفات",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : BlocBuilder<LiveDetectionCubit, LiveDetectionState>(
                        builder: (context, state) {
                          // Get detections from state
                          List<Detection> detections;
                          if (state is LiveDetectionActive) {
                            detections = state.detections;
                          } else {
                            detections = [];
                          }
                          // Check if controller is still valid
                          if (controller == null ||
                              !controller!.value.isInitialized) {
                            return const Center(
                              child: Text("Camera not available"),
                            );
                          }

                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              CameraPreview(controller!),
                              // Show scanning or detection status
                              Positioned(
                                top: 8,
                                left: 8,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        detections.isEmpty
                                            ? Colors.green.withOpacity(0.85)
                                            : Colors.red.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (detections.isEmpty)
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      else
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      const SizedBox(width: 8),
                                      Text(
                                        detections.isEmpty
                                            ? 'Scanning...'
                                            : '${detections.length} pest${detections.length > 1 ? 's' : ''} detected!',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Show detection info cards when pests found
                              if (detections.isNotEmpty)
                                Positioned(
                                  bottom: 60,
                                  left: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                          detections
                                              .map(
                                                (d) => Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.bug_report,
                                                          color:
                                                              Colors.redAccent,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              d.label,
                                                              style: const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Confidence: ${(d.confidence * 100).toStringAsFixed(1)}%',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                      0.7,
                                                                    ),
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                                ),
                              CustomPaint(
                                painter: DetectionPainter(detections),
                                child: Container(),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  onPressed: stopCamera,
                                  child: const Icon(Icons.stop),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
