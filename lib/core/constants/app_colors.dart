import 'package:flutter/material.dart';

/// Centralized color palette for the entire application.
/// Matches the provided aviation-themed dark UI design.
class AppColors {
  AppColors._();

  // Primary Background (dark navy - used in splash, CG visualizer)
  static const Color primaryBackground = Color(0xFF081B36);

  // Primary Blue (buttons, selected nav tab, accents)
  static const Color primaryBlue = Color(0xFF1E88E5);

  // Status Colors
  static const Color green = Color(0xFF2ECC71); // SAFE
  static const Color orange = Color(0xFFF39C12); // WARNING / NEAR LIMIT
  static const Color red = Color(0xFFE74C3C); // UNSAFE

  // Surfaces
  static const Color whiteCard = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF4F5F7);

  // Text
  static const Color textPrimary = Color(0xFF1B2430);
  static const Color textSecondary = Color(0xFF8A94A6);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xB3FFFFFF);

  // Utility
  static const Color divider = Color(0xFFE7E9EE);
  static const Color shadow = Color(0x1A0B1E3D);

  /// Returns the correct status color for a given CG status string.
  static Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SAFE':
        return green;
      case 'WARNING':
      case 'NEAR LIMIT':
        return orange;
      case 'UNSAFE':
        return red;
      default:
        return textSecondary;
    }
  }
}
