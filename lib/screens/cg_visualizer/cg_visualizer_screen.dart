import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/status_model.dart';
import '../../providers/cg_provider.dart';

class CgVisualizerScreen extends StatelessWidget {
  const CgVisualizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cg = context.watch<CgProvider>();
    final result = cg.result;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        title: const Text('CG Visualizer'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.info_outline, color: AppColors.textOnDarkMuted),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            children: [
              // VISUAL / DATA toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text('VISUAL',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => context.push('/weight-distribution'),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: const Text('DATA',
                              style: TextStyle(color: AppColors.textOnDarkMuted, fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Aircraft top-view visualization with animated CG marker
              Expanded(
                child: Center(
                  child: _AircraftCgView(normalizedPosition: result.normalizedPosition),
                ),
              ),

              const SizedBox(height: 20),

              // Limit readouts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LimitReadout(label: 'AFT LIMIT', value: '${result.forwardLimitIn.toStringAsFixed(1)} in'),
                  _LimitReadout(
                    label: 'CG POSITION',
                    value: '${result.centerOfGravityIn.toStringAsFixed(1)} in',
                    highlight: true,
                  ),
                  _LimitReadout(label: 'FWD LIMIT', value: '${result.aftLimitIn.toStringAsFixed(1)} in'),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: Row(
                  children: [
                    StatusBadge(status: result.status),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        result.status.label == 'SAFE'
                            ? 'CG is within the allowable limits.'
                            : 'CG is close to or outside allowable limits.',
                        style: const TextStyle(color: AppColors.textOnDarkMuted, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingM),

              CustomButton(
                label: 'View Detailed Data',
                icon: Icons.arrow_forward,
                onPressed: () => context.push('/weight-distribution'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LimitReadout extends StatelessWidget {
  const _LimitReadout({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textOnDarkMuted, fontSize: 10, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.green : AppColors.textOnDark,
            fontSize: highlight ? 18 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Aircraft top-view silhouette with a green center track and an
/// animated marker that slides to the current normalized CG position.
class _AircraftCgView extends StatelessWidget {
  const _AircraftCgView({required this.normalizedPosition});

  final double normalizedPosition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackHeight = constraints.maxHeight * 0.6;
        final markerTop = trackHeight * normalizedPosition;

        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Aircraft silhouette
            Image.asset(
              'assets/images/airplane.png',
              width: constraints.maxWidth * 0.55,
              fit: BoxFit.contain,
            ),
              // Green center track line
              Positioned(
                top: constraints.maxHeight * 0.18,
                child: Container(
                  width: 2,
                  height: trackHeight,
                  color: AppColors.green.withOpacity(0.5),
                ),
              ),
              // Animated CG marker
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                top: constraints.maxHeight * 0.18 + markerTop - 10,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(color: AppColors.green.withOpacity(0.6), blurRadius: 12, spreadRadius: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
