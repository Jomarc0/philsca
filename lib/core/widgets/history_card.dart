import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../models/history_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.record});

  final HistoryModel record;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(record.timestamp);
    final timeStr = DateFormat('hh:mm a').format(record.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.whiteCard,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: AppTheme.softCardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateStr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(timeStr, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MiniStat(label: 'Total Weight', value: '${record.totalWeightKg.toStringAsFixed(0)} kg'),
                    const SizedBox(width: 20),
                    _MiniStat(label: 'CG Position', value: '${record.centerOfGravityIn.toStringAsFixed(1)} in'),
                  ],
                ),
              ],
            ),
          ),
          StatusBadge(status: record.status, compact: true),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
