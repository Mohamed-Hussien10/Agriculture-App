import 'package:agriculture_app/Features/Actions/data/models/action_model.dart';
import 'package:agriculture_app/Features/Actions/presentation/manager/actions_cubit.dart';
import 'package:agriculture_app/Features/Actions/presentation/manager/actions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agriculture_app/Features/Actions/presentation/view/widgets/action_item.dart';
import 'package:agriculture_app/Features/Actions/presentation/view/widgets/recommendation_item.dart';
import 'package:agriculture_app/Features/Actions/presentation/view/widgets/section_card.dart';

class ActionsScreen extends StatelessWidget {
  const ActionsScreen({super.key});

  void _showAddActionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final cubit = context.read<ActionsCubit>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              'إضافة إجراء جديد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A3D38),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان الإجراء',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'وصف الإجراء',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            actions: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF0A3D38),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(
                      color: Color(0xFF0A3D38),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      cubit.addAction(
                        ActionItemModel(
                          title: titleController.text,
                          description: descriptionController.text,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3D38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'حفظ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionsCubit, ActionsState>(
      builder: (context, state) {
        final cubit = context.read<ActionsCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFF0A3D38),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddActionDialog(context),
            backgroundColor: Color(0xFF0A3D38),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: const Text(
                    'التوصيات والإجراءات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
                      child: Column(
                        children: [
                          // Recommendations
                          const SectionCard(
                            title: "التوصيات - المصائد",
                            icon: Icons.bug_report_rounded,
                            children: [
                              RecommendationItem(
                                name: "مصائد لاصقة صفراء",
                                description:
                                    "وضع المصائد في الأماكن المناسبة لرصد الحشرات.",
                              ),
                              RecommendationItem(
                                name: "مصائد فرمونية",
                                description:
                                    "استخدام المصائد الفرمونية لجذب الحشرات المستهدفة.",
                              ),
                              RecommendationItem(
                                name: "مصائد مائية ملونة",
                                description:
                                    "وضع المصائد الملونة المائية لجذب الحشرات الطائرة.",
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          const SectionCard(
                            title: "التوصيات - المبيدات الحيوية",
                            icon: Icons.science_rounded,
                            children: [
                              RecommendationItem(
                                name: "المبيد 1: إيمامكتين بنزوات",
                                description:
                                    "استخدام المبيد الحيوي بمعدل التركيز الموصى به.",
                              ),
                              RecommendationItem(
                                name: "المبيد 2: اسبينوساد",
                                description:
                                    "تطبيق المبيد على النباتات المصابة وفق التوجيهات.",
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // User saved actions
                          if (state is ActionsLoaded &&
                              state.actions.isNotEmpty)
                            SectionCard(
                              title: "إجراءاتك المحفوظة",
                              icon: Icons.list_alt_rounded,
                              children: [
                                for (var action in state.actions) ...[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ActionItem(
                                          number: "-",
                                          title: action.title,
                                          description: action.description,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed:
                                            () => cubit.deleteAction(action),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
