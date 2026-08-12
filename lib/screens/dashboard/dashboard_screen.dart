import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../models/status_model.dart';
import '../../providers/bluetooth_provider.dart';
import '../../providers/cg_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bt = context.watch<BluetoothProvider>();
    final cg = context.watch<CgProvider>();
    final result = cg.result;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: const Icon(Icons.menu, color: AppColors.textOnDark),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        children: [
          // Device Connected Card
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            child: Row(
              children: [
                Icon(Icons.bluetooth_connected,
                    color: bt.isConnected
                        ? AppColors.primaryBlue
                        : AppColors.textOnDarkMuted),
                const SizedBox(width: 10),
                Text(
                  bt.isConnected ? 'Device Connected' : 'Device Disconnected',
                  style: const TextStyle(
                      color: AppColors.textOnDark, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(Icons.battery_full, color: AppColors.green, size: 18),
                const SizedBox(width: 4),
                Text('${bt.batteryPercent}%',
                    style: const TextStyle(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: AppSizes.paddingL),

          Text("TODAY'S STATUS",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),

          // Today's Status card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.whiteCard,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              boxShadow: AppTheme.softCardShadow,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    result.status.label,
                    style: TextStyle(
                      color: result.status.color,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.check_circle,
                      color: result.status.color, size: 26),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

          const SizedBox(height: AppSizes.paddingL),

          // Total Weight + CG cards
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'TOTAL\nWEIGHT',
                  value: result.totalWeightKg.toStringAsFixed(0),
                  unit: 'kg',
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: _StatTile(
                  label: 'CENTER\nOF GRAVITY',
                  value: result.centerOfGravityIn.toStringAsFixed(1),
                  unit: 'in',
                  icon: Icons.gps_fixed,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

          const SizedBox(height: AppSizes.paddingM),

          // Aircraft Status card
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
                      Text('AIRCRAFT STATUS',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(result.status.label,
                          style: TextStyle(
                              color: result.status.color,
                              fontWeight: FontWeight.w800,
                              fontSize: 18)),
                      Text('Within CG Limits',
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: result.status.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.flight, color: result.status.color),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: AppSizes.paddingM),

          // Aircraft Information card
          InkWell(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.whiteCard,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                boxShadow: AppTheme.softCardShadow,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AIRCRAFT',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(cg.aircraft.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.airplanemode_active,
                      color: AppColors.primaryBlue),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

          const SizedBox(height: AppSizes.paddingL),

          // Quick nav grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSizes.paddingM,
            mainAxisSpacing: AppSizes.paddingM,
            childAspectRatio: 2.4,
            children: [
              _QuickNavButton(
                  icon: Icons.podcasts,
                  label: 'Live Monitoring',
                  onTap: () => context.go('/live')),
              _QuickNavButton(
                  icon: Icons.center_focus_strong,
                  label: 'CG Visualizer',
                  onTap: () => context.go('/cg')),
              _QuickNavButton(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () => context.go('/history')),
              _QuickNavButton(
                  icon: Icons.table_chart_outlined,
                  label: 'Weight Table',
                  onTap: () => context.push('/weight-distribution')),
            ],
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.label,
      required this.value,
      required this.unit,
      required this.icon});

  final String label;
  final String value;
  final String unit;
  final IconData icon;

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
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(width: 4),
              Text(unit, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickNavButton extends StatelessWidget {
  const _QuickNavButton(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    color: AppColors.textOnDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
