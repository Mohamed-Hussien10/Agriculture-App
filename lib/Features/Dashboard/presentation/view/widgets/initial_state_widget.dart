import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/model_cubit.dart';
import '../widgets/buttons.dart';

class InitialStateWidget extends StatelessWidget {
  final File? image;
  final AnimationController animationController;

  const InitialStateWidget({
    super.key,
    required this.image,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final isImageSelected = image != null;

    return AnalyzeButton(
      isEnabled: isImageSelected,
      onPressed: () {
        animationController.forward(from: 0.0);
        context.read<ModelCubit>().detect(image!);
      },
    );
  }
}