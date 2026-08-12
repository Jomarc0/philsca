import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_bottom_nav_bar.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/live_monitoring/live_monitoring_screen.dart';
import 'screens/cg_visualizer/cg_visualizer_screen.dart';
import 'screens/weight_distribution/weight_distribution_screen.dart';
import 'screens/history/history_screen.dart';

class CgWeightBalanceApp extends StatelessWidget {
  const CgWeightBalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Portable Center of Gravity Computing Device',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // Detail route that lives outside the bottom-nav shell.
    GoRoute(
      path: '/weight-distribution',
      builder: (context, state) => const WeightDistributionScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => _MainShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
        GoRoute(path: '/live', builder: (context, state) => const LiveMonitoringScreen()),
        GoRoute(path: '/cg', builder: (context, state) => const CgVisualizerScreen()),
        GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
      ],
    ),
  ],
);

/// Shell hosting the four primary tabs behind the shared bottom nav bar.
class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});

  final Widget child;

  static const _tabPaths = ['/dashboard', '/live', '/cg', '/history'];

  int _indexForLocation(String location) {
    final index = _tabPaths.indexWhere((p) => location.startsWith(p));
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index < _tabPaths.length) {
            context.go(_tabPaths[index]);
          }
        },
      ),
    );
  }
}
