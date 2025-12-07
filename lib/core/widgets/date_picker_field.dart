import 'package:agriculture_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerField extends FormField<DateTime> {
  DatePickerField({
    super.key,
    String label = 'Date of Birth',
    bool isRequired = true,
    super.initialValue,
    required Future<void> Function(BuildContext, FormFieldState<DateTime>)
    onTap,
    super.validator,
  }) : super(
         builder: (FormFieldState<DateTime> state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SelectionArea(
                 child: Row(
                   children: [
                     Text(
                       label,
                       style: TextStyle(
                         fontSize: 14.sp,
                         fontWeight: FontWeight.w500,
                         color: AppColors.textSecondary,
                       ),
                     ),
                     Text(
                       isRequired ? ' *' : '',
                       style: const TextStyle(
                         fontSize: 14,
                         fontWeight: FontWeight.w500,
                         color: Colors.red,
                       ),
                     ),
                   ],
                 ),
               ),
               const SizedBox(height: 8),
               InkWell(
                 onTap: () => onTap(state.context, state),
                 child: Container(
                   height: 50,
                   padding: const EdgeInsets.symmetric(horizontal: 16),
                   decoration: BoxDecoration(
                     color: Colors.white.withOpacity(0.9),
                     borderRadius: BorderRadius.circular(12),
                     border: Border.all(
                       color:
                           state.hasError
                               ? Colors.red
                               : const Color(0xFFE9ECEF),
                     ),
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Flexible(
                         child: Text(
                           state.value == null
                               ? 'Select date'.tr()
                               : '${DateFormat('d', 'en').format(state.value!)} '
                                   '${DateFormat.MMMM(Localizations.localeOf(state.context).toString()).format(state.value!)} '
                                   '${DateFormat('yyyy', 'en').format(state.value!)}',
                           style: TextStyle(
                             fontSize: 14.sp,
                             color:
                                 state.value == null
                                     ? const Color(0xFF6C757D)
                                     : const Color(0xFF212529),
                           ),
                           overflow: TextOverflow.ellipsis, // Prevent overflow
                         ),
                       ),

                       const Icon(
                         Icons.calendar_today_rounded,
                         color: Color(0xFF6C757D),
                       ),
                     ],
                   ),
                 ),
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0),
                   child: Text(
                     state.errorText!,
                     style: const TextStyle(color: Colors.red, fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );
}
