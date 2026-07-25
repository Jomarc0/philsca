import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/sensor_tile.dart';
import '../../core/widgets/status_badge.dart';
import '../../providers/bluetooth_provider.dart';
import '../../providers/cg_provider.dart';

class LiveMonitoringScreen extends StatefulWidget {
  const LiveMonitoringScreen({super.key});

  @override
  State<LiveMonitoringScreen> createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  bool _refreshing = false;

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    await context.read<CgProvider>().refreshFromDevice();
    if (mounted) setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cg = context.watch<CgProvider>();
    final bt = context.watch<BluetoothProvider>();
    final result = cg.result;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(title: const Text('Live Monitoring')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              children: [
                const SectionHeader(title: 'Sensor Readings', liveIndicator: true),
                const SizedBox(height: AppSizes.paddingM),
                ...cg.sensors.map((s) => SensorTile(sensor: s)),
              ],
            ),
          ),
          // Bottom summary panel
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingL, AppSizes.paddingL, AppSizes.paddingL, AppSizes.paddingM,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SummaryStat(label: 'TOTAL WEIGHT', value: '${result.totalWeightKg.toStringAsFixed(0)} kg'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('CENTER OF GRAVITY',
                              style: const TextStyle(color: AppColors.textOnDarkMuted, fontSize: 11, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('${result.centerOfGravityIn.toStringAsFixed(1)} in',
                                  style: const TextStyle(color: AppColors.textOnDark, fontSize: 20, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              StatusBadge(status: result.status, compact: true),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Refresh',
                          icon: Icons.refresh,
                          variant: CustomButtonVariant.secondary,
                          isLoading: _refreshing,
                          onPressed: _refresh,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: CustomButton(
                          label: bt.isConnected ? 'Disconnect' : 'Connect',
                          icon: bt.isConnected ? Icons.bluetooth_disabled : Icons.bluetooth,
                          variant: CustomButtonVariant.danger,
                          onPressed: () => bt.isConnected ? bt.disconnect() : bt.connect(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textOnDarkMuted, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textOnDark, fontSize: 20, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
