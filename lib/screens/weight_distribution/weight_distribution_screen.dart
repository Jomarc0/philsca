import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../providers/cg_provider.dart';

class WeightDistributionScreen extends StatelessWidget {
  const WeightDistributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cg = context.watch<CgProvider>();
    final result = cg.result;
    final sensors = cg.sensors;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(title: const Text('Weight Distribution')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        children: [
          // Responsive data table
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteCard,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              boxShadow: AppTheme.softCardShadow,
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.lightGray),
                columnSpacing: 28,
                columns: const [
                  DataColumn(label: Text('STATION')),
                  DataColumn(label: Text('WEIGHT\n(kg)'), numeric: true),
                  DataColumn(label: Text('ARM\n(in)'), numeric: true),
                  DataColumn(label: Text('MOMENT\n(kg-in)'), numeric: true),
                ],
                rows: sensors
                    .map(
                      (s) => DataRow(cells: [
                        DataCell(Text(s.stationName, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(s.weightKg.toStringAsFixed(0))),
                        DataCell(Text(s.armIn.toStringAsFixed(1))),
                        DataCell(Text(s.momentKgIn.toStringAsFixed(0))),
                      ]),
                    )
                    .toList(),
              ),
            ),
          ),

          const SizedBox(height: AppSizes.paddingL),

          Row(
            children: [
              Expanded(
                child: _TotalCard(
                  label: 'TOTAL WEIGHT',
                  value: '${result.totalWeightKg.toStringAsFixed(0)} kg',
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: _TotalCard(
                  label: 'TOTAL MOMENT',
                  value: '${result.totalMomentKgIn.toStringAsFixed(0)} kg-in',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingM),

          Container(
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
                      Text('CENTER OF GRAVITY', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('${result.centerOfGravityIn.toStringAsFixed(1)} in',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                StatusBadge(status: result.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.whiteCard,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: AppTheme.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
