import 'dart:io';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/error_state_widget.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/image_picker_widget.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/initial_state_widget.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/loading_state_widget.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/result_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/model_cubit.dart';
import '../../manager/model_state.dart';

class ModelDetectionSection extends StatefulWidget {
  final File? image;
  final VoidCallback onPickImage;

  const ModelDetectionSection({
    super.key,
    required this.image,
    required this.onPickImage,
  });

  @override
  State<ModelDetectionSection> createState() => _ModelDetectionSectionState();
}

class _ModelDetectionSectionState extends State<ModelDetectionSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decorative background element
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                _buildHeader(),
                const SizedBox(height: 20),

                /// IMAGE PICKER
                ImagePickerWidget(
                  image: widget.image,
                  onTap: widget.onPickImage,
                ),

                const SizedBox(height: 16),

                /// MODEL RESULT
                BlocBuilder<ModelCubit, ModelState>(
                  builder: (context, state) {
                    if (state is ModelLoading) {
                      return LoadingStateWidget();
                    }

                    if (state is ModelLoaded) {
                      return ResultStateWidget(
                        state: state,
                        animationController: _animationController,
                        onPickImage: widget.onPickImage,
                      );
                    }

                    if (state is ModelError) {
                      return ErrorStateWidget(
                        state: state,
                        image: widget.image,
                        animationController: _animationController,
                      );
                    }

                    return InitialStateWidget(
                      image: widget.image,
                      animationController: _animationController,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.bug_report_outlined,
            color: Colors.green.shade700,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'اكتشاف الآفات الزراعية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'بشكل فوري',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
