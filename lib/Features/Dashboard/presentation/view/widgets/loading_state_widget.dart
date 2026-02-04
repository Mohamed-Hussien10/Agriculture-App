import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue.shade400),
                  strokeWidth: 4,
                ),
              ),
              Icon(
                Icons.image_search,
                size: 40,
                color: Colors.blue.shade600,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحليل الصورة...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}