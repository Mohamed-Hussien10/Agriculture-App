import 'package:flutter/material.dart';
import '../../manager/model_state.dart';
import '../widgets/buttons.dart';
import '../widgets/detection_card.dart';

class ResultStateWidget extends StatelessWidget {
  final ModelLoaded state;
  final AnimationController animationController;
  final VoidCallback onPickImage;

  const ResultStateWidget({
    super.key,
    required this.state,
    required this.animationController,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    final List detections = data['detections'] ?? [];
    final int count = data['count'] ?? 0;

    if (count == 0) {
      return Column(
        children: [
          _buildNoDetectionsMessage(),
          const SizedBox(height: 12),
          UploadAnotherButton(onPickImage: onPickImage),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetectionCountMessage(count),
        const SizedBox(height: 12),
        ..._buildDetectionCards(detections),
        const SizedBox(height: 12),
        UploadAnotherButton(onPickImage: onPickImage),
      ],
    );
  }

  Widget _buildNoDetectionsMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.shade600,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'لم يتم اكتشاف أي آفات',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionCountMessage(int count) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade600,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'تم اكتشاف $count ${count == 1 ? 'آفة' : 'آفات'}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetectionCards(List<dynamic> detections) {
    return detections.asMap().entries.map((entry) {
      final index = entry.key;
      final detection = entry.value;

      return DetectionCard(
        index: index,
        detection: detection,
        scaleAnimation: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOut,
          ),
        ),
      );
    }).toList();
  }
}