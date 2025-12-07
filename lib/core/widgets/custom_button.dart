import 'package:agriculture_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, cancel }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final Widget? trailing;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.trailing, Color? backgroundColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = _getButtonColors();
    final isDisabled = widget.onPressed == null;
    final borderRadius = BorderRadius.circular(12);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = !isDisabled ? true : false),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown:
            (_) => setState(() => _isPressed = !isDisabled ? true : false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: 52,
          decoration: BoxDecoration(
            gradient:
                widget.type == ButtonType.primary && !isDisabled
                    ? LinearGradient(
                      colors: [
                        _isPressed ? AppColors.primaryDark : AppColors.primary,
                        _isPressed
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color:
                isDisabled
                    ? AppColors.textTertiary.withOpacity(
                      0.3,
                    ) // Greyed-out for disabled
                    : widget.type != ButtonType.primary
                    ? _isPressed
                        ? colors.backgroundColor.withOpacity(0.9)
                        : colors.backgroundColor
                    : null,
            border: Border.all(
              color:
                  isDisabled
                      ? AppColors.textTertiary.withOpacity(0.5)
                      : _isPressed
                      ? colors.borderColor.withOpacity(0.8)
                      : colors.borderColor,
              width: 1.5,
            ),
            borderRadius: borderRadius,
            boxShadow:
                _isHovered && !isDisabled
                    ? [
                      BoxShadow(
                        color: colors.shadowColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: widget.onPressed,
              child: Center(
                child:
                    widget.isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                size: 20,
                                color:
                                    isDisabled
                                        ? AppColors.textTertiary.withOpacity(
                                          0.7,
                                        )
                                        : colors.textColor,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Text(
                                widget.text,
                                style: TextStyle(
                                  color:
                                      isDisabled
                                          ? AppColors.textTertiary.withOpacity(
                                            0.7,
                                          )
                                          : colors.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.trailing != null) ...[
                              const SizedBox(width: 8),
                              widget.trailing!,
                            ],
                          ],
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _getButtonColors() {
    switch (widget.type) {
      case ButtonType.primary:
        return _ButtonColors(
          textColor: AppColors.white,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          shadowColor: AppColors.primary,
        );
      case ButtonType.secondary:
        return _ButtonColors(
          textColor: AppColors.primary,
          backgroundColor: AppColors.white,
          borderColor: AppColors.primary,
          shadowColor: AppColors.primary,
        );
      case ButtonType.cancel:
        return _ButtonColors(
          textColor: AppColors.error,
          backgroundColor: AppColors.white,
          borderColor: AppColors.error,
          shadowColor: AppColors.error,
        );
    }
  }
}

class _ButtonColors {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;

  _ButtonColors({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
  });
}
