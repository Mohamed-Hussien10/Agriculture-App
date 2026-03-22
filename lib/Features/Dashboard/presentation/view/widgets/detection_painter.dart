import 'package:flutter/material.dart';

class Detection {
  final Rect rect;
  final String label;
  final double confidence;
  final Color color;

  Detection({
    required this.rect,
    required this.label,
    required this.confidence,
    required this.color,
  });
}

class DetectionPainter extends CustomPainter {
  final List<Detection> detections;

  DetectionPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // debug canvas
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.blue.withOpacity(0.1)
        ..style = PaintingStyle.stroke,
    );

    for (var d in detections) {
      final paint =
          Paint()
            ..color = d.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      // نضبط الـ rectangle على حجم الـ canvas
      final rect = Rect.fromLTWH(
        d.rect.left * size.width,
        d.rect.top * size.height,
        d.rect.width * size.width,
        d.rect.height * size.height,
      );

      canvas.drawRect(rect, paint);

      final textSpan = TextSpan(
        text: '${d.label} ${(d.confidence * 100).toStringAsFixed(1)}%',
        style: TextStyle(
          color: d.color,
          fontSize: 14,
          backgroundColor: Colors.white70,
        ),
      );
      textPainter.text = textSpan;
      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 18));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
