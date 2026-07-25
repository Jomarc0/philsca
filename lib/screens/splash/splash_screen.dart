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
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Logo
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textOnDarkMuted, width: 1.5),
              ),
              child: const Icon(Icons.flight, color: AppColors.textOnDark, size: 56),
            ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppStrings.appName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textOnDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  letterSpacing: 0.5,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.15, end: 0),
            const SizedBox(height: 10),
            Text(
              AppStrings.appTagline,
              style: const TextStyle(
                color: AppColors.textOnDarkMuted,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const Spacer(flex: 2),
            // Aircraft near the bottom
            Image.asset(
              'assets/images/airplane.png',
              height: 170,
              fit: BoxFit.contain,
            ).animate().fadeIn(delay: 300.ms, duration: 900.ms),
            const SizedBox(height: 24),
            const Text(
              'LOADING...',
              style: TextStyle(
                color: AppColors.textOnDarkMuted,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 140,
              child: LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: AppColors.textOnDark.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
