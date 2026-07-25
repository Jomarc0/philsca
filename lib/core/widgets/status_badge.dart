import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../../models/status_model.dart';

/// Pill-shaped status badge (SAFE / WARNING / UNSAFE) used across
/// Dashboard, Live Monitoring, CG Visualizer, Weight Distribution,
/// and History screens.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  final CgStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 4 : 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: compact ? 12 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 10 : 12,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
