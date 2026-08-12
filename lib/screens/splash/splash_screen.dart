import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A2E),
      body: Stack(
        children: [
          // MAIN BACKGROUND - Very dark navy gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF001A2E), // Very dark navy (top)
                  Color(0xFF00243A), // Dark navy
                  Color(0xFF001A2E), // Very dark navy
                  Color(0xFF000F1C), // Almost black (bottom)
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ===============================
                // TOP LOGO + TITLE (CENTERED)
                // ===============================
                Expanded(
                  flex: 48,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // LOGO
                            Image.asset(
                              'assets/images/LOGO.png',
                              width: 160,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 32),

                            // TITLE
                            const Text(
                              'PORTABLE\nCENTER OF GRAVITY\nCOMPUTING DEVICE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                height: 1.35,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // SEPARATOR LINE
                            Container(
                              width: 280,
                              height: 1,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 28),

                            // SUBTITLE
                            const Text(
                              'WEIGHT & BALANCE SYSTEM',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.5,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ===============================
                // AIRCRAFT IMAGE
                // ===============================
                Expanded(
                  flex: 34,
                  child: SizedBox(
                    width: double.infinity,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.transparent,
                          ],
                          stops: [
                            0.0,
                            0.55,
                            0.75,
                            1.0,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/images/plane.jpg',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),

                // ===============================
                // LOADING SECTION
                // ===============================
                Expanded(
                  flex: 18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text(
                        'LOADING...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            minHeight: 6,
                            backgroundColor: Color(0xFF1A3A52),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF1E88E5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
