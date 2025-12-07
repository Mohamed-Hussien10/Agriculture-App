import 'package:agriculture_app/Features/Actions/presentation/view/widgets/action_item.dart';
import 'package:agriculture_app/Features/Actions/presentation/view/widgets/documentation_item.dart';
import 'package:agriculture_app/Features/Actions/presentation/view/widgets/recommendation_item.dart';
import 'package:agriculture_app/Features/Actions/presentation/view/widgets/section_card.dart';
import 'package:flutter/material.dart';

class ActionsScreen extends StatelessWidget {
  const ActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D38),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  const Text(
                    'التوصيات والإجراءات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
                  child: Column(
                    children: [
                      // تحليل المشكلة
                      const SectionCard(
                        title: "تحليل المشكلة (بناءً على البيانات)",
                        icon: Icons.analytics_rounded,
                        content:
                            "بناءً على الارتفاع المفاجئ في الحركة والتنبيهات البيئية، يلزم اتخاذ إجراء تصحيحي فوري للتحكم في مستوى الرطوبة وتجنب تفاقم المشكلة.",
                      ),
                      const SizedBox(height: 16),

                      // التوصية الأساسية
                      SectionCard(
                        title: "التوصية الأساسية",
                        icon: Icons.lightbulb_rounded,
                        children: const [
                          RecommendationItem(
                            name: "الإجراء التصحيحي (X): إجراء حرج",
                            description:
                                "رش المحلول الكيميائي المعتمد بتركيز 1.5 مل/لتر (محسوب تلقائيًا).",
                          ),
                          SizedBox(height: 14),
                          RecommendationItem(
                            name: "الجدول الزمني للتنفيذ (Y): الليلة أو فورًا",
                            description:
                                "يجب التنفيذ فورًا لمنع تفاقم المشكلة.",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // الإجراءات البيئية المساندة
                      SectionCard(
                        title: "الإجراءات البيئية المساندة",
                        icon: Icons.eco_rounded,
                        children: const [
                          ActionItem(
                            number: "1",
                            title: "تعزيز التهوية",
                            description:
                                "زيادة تشغيل التهوية لمدة 30 دقيقة (لخفض الرطوبة).",
                          ),
                          SizedBox(height: 14),
                          ActionItem(
                            number: "2",
                            title: "تعديل الري اليومي",
                            description:
                                "تقليل كمية المياه اليومية بنسبة 10% (للتحكم في الرطوبة).",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // توثيق التنفيذ
                      SectionCard(
                        title: "توثيق تنفيذ الإجراء",
                        icon: Icons.description_rounded,
                        children: const [
                          DocumentationItem(
                            label: "عرض السجلات التفصيلية",
                            description: "تم بدء التنفيذ (الحالة: قيد التنفيذ)",
                          ),
                          SizedBox(height: 12),
                          DocumentationItem(
                            label: "ملاحظة التنفيذ",
                            description:
                                "اضغط للانتقال إلى لوحة تحكم مبسطة. المتابعة: (تسجيل التاريخ/الوقت/الملاحظات)",
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A3D38),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 8,
                                shadowColor: Colors.black26,
                              ),
                              onPressed: () {
                                // تنفيذ الإجراءات
                              },
                              child: const Text(
                                "تنفيذ الإجراءات",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0A3D38),
                                side: const BorderSide(
                                  color: Color(0xFF0A3D38),
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "تجاهل",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
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
  }
}
