import 'package:flutter/material.dart';

class RecommendationItem extends StatelessWidget {
  final String name;
  final String description;

  const RecommendationItem({
    super.key,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0A3D38)),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF4B5563)),
        ),
      ],
    );
  }
}