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
    final hasData = !result.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(title: const Text('Weight Distribution')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        children: [
          if (hasData)
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
            )
          else
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.whiteCard,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                boxShadow: AppTheme.softCardShadow,
              ),
              child: const Column(
                children: [
                  Icon(Icons.table_rows, size: 40, color: AppColors.textSecondary),
                  SizedBox(height: 12),
                  Text(
                    'No data record yet',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Add a load entry to populate the weight table.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

          const SizedBox(height: AppSizes.paddingL),

          Row(
            children: [
              Expanded(
                child: _TotalCard(
                  label: 'TOTAL WEIGHT',
                  value: hasData ? '${result.totalWeightKg.toStringAsFixed(0)} kg' : '--',
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: _TotalCard(
                  label: 'TOTAL MOMENT',
                  value: hasData ? '${result.totalMomentKgIn.toStringAsFixed(0)} kg-in' : '--',
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
                      Text(hasData ? '${result.centerOfGravityIn.toStringAsFixed(1)} in' : '--',
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
