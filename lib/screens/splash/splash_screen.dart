import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: [
          const _SplashBackdrop(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SmallBadge(label: 'LIVE'),
                      _SmallBadge(label: 'SAFE'),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms),
                const Spacer(flex: 2),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/LOGO.png',
                      width: 170,
                      height: 170,
                      fit: BoxFit.contain,
                    )
                        .animate()
                        .fadeIn(duration: 650.ms)
                        .scale(
                          begin: const Offset(0.84, 0.84),
                          end: const Offset(1, 1),
                          duration: 650.ms,
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        AppStrings.appName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textOnDark,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(begin: 0.12, end: 0),
                    const SizedBox(height: 12),
                    const Text(
                      'WEIGHT & BALANCE SYSTEM',
                      style: TextStyle(
                        color: AppColors.textOnDarkMuted,
                        fontSize: 12,
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
                  ],
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/plane.jpg',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 800.ms)
                    .slideY(begin: 0.08, end: 0),
                const Spacer(flex: 2),
                const Text(
                  'LOADING...',
                  style: TextStyle(
                    color: AppColors.textOnDarkMuted,
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                const SizedBox(height: 14),
                SizedBox(
                  width: 180,
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: AppColors.textOnDark.withOpacity(0.12),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF05111F),
            AppColors.primaryBackground,
            Color(0xFF041021),
          ],
          stops: [0.0, 0.48, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.25),
            radius: 1.2,
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textOnDarkMuted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
