import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

enum CustomButtonVariant { primary, secondary, danger }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = CustomButtonVariant.primary,
    this.expand = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final CustomButtonVariant variant;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(variant);

    final child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: colors.foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: colors.foreground),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          side: colors.border != null
              ? BorderSide(color: colors.border!, width: 1.2)
              : BorderSide.none,
        ),
      ),
      child: child,
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  _ButtonColors _colorsFor(CustomButtonVariant variant) {
    switch (variant) {
      case CustomButtonVariant.primary:
        return const _ButtonColors(
          background: AppColors.primaryBlue,
          foreground: AppColors.textOnDark,
        );
      case CustomButtonVariant.secondary:
        return const _ButtonColors(
          background: AppColors.lightGray,
          foreground: AppColors.textPrimary,
          border: AppColors.divider,
        );
      case CustomButtonVariant.danger:
        return const _ButtonColors(
          background: Color(0xFFFDECEA),
          foreground: AppColors.red,
        );
    }
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}
