import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.trailingIcon,
    this.liveIndicator = false,
  });

  final String title;
  final String? trailing;
  final IconData? trailingIcon;
  final bool liveIndicator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (liveIndicator)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'LIVE',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.green,
                    ),
              ),
            ],
          )
        else if (trailing != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trailing!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, size: 14, color: AppColors.primaryBlue),
            ],
          ),
      ],
    );
  }
}
