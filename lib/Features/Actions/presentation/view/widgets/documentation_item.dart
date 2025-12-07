import 'package:flutter/material.dart';

class DocumentationItem extends StatelessWidget {
  final String label;
  final String description;

  const DocumentationItem({
    super.key,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("• ", style: TextStyle(fontSize: 18, color: Color(0xFF0A3D38))),
            Text(
              label,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0A3D38)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            description,
            style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF4B5563)),
          ),
        ),
      ],
    );
  }
}