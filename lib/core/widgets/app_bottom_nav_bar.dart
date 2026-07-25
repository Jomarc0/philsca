import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// Exactly four tabs per the design spec: Dashboard, Live, CG, History.
/// The selected tab uses the primary blue color.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  // Exactly four tabs per the design spec: Dashboard, Live, CG, History.
  static const _items = [
    _NavItemData(icon: Icons.home_outlined, activeIcon: Icons.home, label: AppStrings.navHome),
    _NavItemData(icon: Icons.podcasts_outlined, activeIcon: Icons.podcasts, label: AppStrings.navLive),
    _NavItemData(icon: Icons.center_focus_strong_outlined, activeIcon: Icons.center_focus_strong, label: AppStrings.navCG),
    _NavItemData(icon: Icons.history_outlined, activeIcon: Icons.history, label: AppStrings.navHistory),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = index == currentIndex;
              final color = selected ? AppColors.primaryBlue : AppColors.textSecondary;

              return InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(selected ? item.activeIcon : item.icon, color: color, size: 22),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.activeIcon, required this.label});
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
