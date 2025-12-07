import 'package:agriculture_app/core/themes/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final ValueChanged<String?>? onChanged;
  final bool isDropdown;
  final String? value;
  final bool isRequired;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.dropdownItems,
    this.onChanged,
    this.isDropdown = false,
    this.value,
    this.isRequired = false,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            children:
                isRequired
                    ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Color(0xFFE74827)),
                      ),
                    ]
                    : [],
          ),
        ),
        const SizedBox(height: 8),
        if (isDropdown)
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              cardColor: Colors.white,
              cardTheme: const CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value:
                    value != null &&
                            dropdownItems?.any((item) => item.value == value) ==
                                true
                        ? value
                        : null,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: hintText ?? '${'Select'.tr()} $label',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  prefixIcon: prefixIcon,
                ),
                items:
                    dropdownItems
                        ?.map(
                          (item) => DropdownMenuItem<String>(
                            value: item.value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xFF212529),
                                ),
                                child: item.child,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: enabled ? onChanged : null,
                validator: validator,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6C757D),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF212529)),
                menuMaxHeight: 300,
              ),
            ),
          )
        else
          TextFormField(
            controller: controller,
            initialValue: value != null && controller == null ? value : null,
            keyboardType:
                keyboardType ??
                (maxLines! > 1 ? TextInputType.multiline : null),
            obscureText: obscureText,
            enabled: enabled,
            maxLines: maxLines,
            minLines: minLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF6C757D)),
              prefixIcon: prefixIcon,
              suffixIcon:
                  suffixIcon != null
                      ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: suffixIcon,
                      )
                      : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF212529)),
            onChanged: onChanged,
            validator: validator,
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
