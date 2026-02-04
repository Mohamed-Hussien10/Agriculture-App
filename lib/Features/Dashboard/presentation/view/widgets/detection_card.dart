import 'package:flutter/material.dart';

class DetectionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> detection;
  final Animation<double> scaleAnimation;

  const DetectionCard({
    super.key,
    required this.index,
    required this.detection,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final bbox = detection['bbox'];
    final confidence = (detection['confidence'] * 100).toStringAsFixed(1);

    return ScaleTransition(
      scale: scaleAnimation,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(confidence),
                const SizedBox(height: 10),
                _buildConfidenceBar(double.parse(confidence)),
                const SizedBox(height: 10),
                _buildCoordinatesSection(bbox),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String confidence) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'الآفة #${index + 1}: ${detection['class_name']}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getConfidenceColor(double.parse(confidence))
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$confidence%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getConfidenceColor(double.parse(confidence)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfidenceBar(double confidence) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'درجة الثقة',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: confidence / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor:
                AlwaysStoppedAnimation(_getConfidenceColor(confidence)),
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinatesSection(Map<String, dynamic> bbox) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'موقع الآفة',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCoordinate(
                'X',
                '${bbox['xmin'].toStringAsFixed(1)} → ${bbox['xmax'].toStringAsFixed(1)}',
              ),
              _buildCoordinate(
                'Y',
                '${bbox['ymin'].toStringAsFixed(1)} → ${bbox['ymax'].toStringAsFixed(1)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinate(String label, String value) {
    return Expanded(
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 10),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.orange;
    return Colors.red;
  }
}