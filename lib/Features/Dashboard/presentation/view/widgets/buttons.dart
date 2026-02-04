import 'package:agriculture_app/Features/Dashboard/presentation/manager/model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class AnalyzeButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const AnalyzeButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: const Icon(Icons.image_search, color: Colors.white),
        label: const Text('تحليل الصورة'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey.shade500,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

class RetryButton extends StatelessWidget {
  final File? image;
  final AnimationController animationController;

  const RetryButton({
    super.key,
    required this.image,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            image != null
                ? () {
                  animationController.forward(from: 0.0);
                  context.read<ModelCubit>().detect(image!);
                }
                : null,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text('حاول مرة أخرى'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey.shade500,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class UploadAnotherButton extends StatelessWidget {
  final VoidCallback onPickImage;

  const UploadAnotherButton({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Reset the cubit state to initial
          context.read<ModelCubit>().reset();
          // Open image picker
          onPickImage();
        },
        icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
        label: const Text('تحميل صورة أخرى'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade500,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
