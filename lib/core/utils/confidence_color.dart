import 'package:flutter/material.dart';

Color getConfidenceColor(double confidence) {
  if (confidence >= 80) return Colors.green;
  if (confidence >= 60) return Colors.orange;
  return Colors.red;
}
