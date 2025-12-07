import 'package:agriculture_app/core/themes/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows a modern, attractive custom SnackBar with smooth animations and professional design.
/// Features gradient background, icon, and optional action button with improved visual hierarchy.
///
/// Parameters:
/// - [context]: The BuildContext to display the SnackBar.
/// - [message]: The message to display, translated using `.tr()`.
/// - [isError]: Whether the SnackBar represents an error (affects styling).
/// - [messageId]: Unique identifier to prevent duplicate SnackBars.
/// - [displayedMessageIds]: Set of message IDs to track displayed SnackBars.
/// - [actionLabel]: Optional text for the action button.
/// - [onActionPressed]: Optional callback for the action button.
/// - [duration]: Optional custom duration for the SnackBar display.
///
/// Returns: A Future that completes when the SnackBar is dismissed.
Future<void> showCustomSnackBar(
  BuildContext context, {
  required String message,
  bool isError = false,
  required String messageId,
  required Set<String> displayedMessageIds,
  String? actionLabel,
  VoidCallback? onActionPressed,
  Duration? duration,
}) async {
  if (displayedMessageIds.contains(messageId)) return;
  displayedMessageIds.add(messageId);

  final snackBar = SnackBar(
    content: TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isError
                    ? [
                      AppColors.error.withOpacity(0.95),
                      AppColors.error.withOpacity(0.8),
                    ]
                    : [
                      AppColors.primary.withOpacity(0.95),
                      AppColors.primary.withOpacity(0.8),
                    ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12.r,
              spreadRadius: 1.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.tr(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (actionLabel != null && onActionPressed != null)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onActionPressed();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                  ),
                  child: Text(
                    actionLabel.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    padding: EdgeInsets.zero,
    duration: duration ?? const Duration(seconds: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
    clipBehavior: Clip.antiAlias,
    elevation: 0,
    dismissDirection: DismissDirection.horizontal,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar).closed.then((_) {
      displayedMessageIds.remove(messageId);
    });
}
