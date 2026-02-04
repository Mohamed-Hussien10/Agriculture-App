import 'package:agriculture_app/Features/Dashboard/presentation/manager/model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadAnotherButton extends StatelessWidget {
  const UploadAnotherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<ModelCubit>().reset();
        },
        icon: const Icon(Icons.add_photo_alternate),
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
