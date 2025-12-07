import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const ActionItem({
    super.key,
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0A3D38).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF0A3D38).withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0A3D38)),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0A3D38)),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF4B5563)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}