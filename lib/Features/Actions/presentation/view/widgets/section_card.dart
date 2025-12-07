import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? content;
  final List<Widget>? children;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.content,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3D38).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF0A3D38), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A3D38),
                  ),
                ),
              ),
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 14),
            Text(
              content!,
              style: const TextStyle(fontSize: 13.5, height: 1.6, color: Color(0xFF374151)),
            ),
          ],
          if (children != null) ...[
            const SizedBox(height: 16),
            ...children!,
          ],
        ],
      ),
    );
  }
}