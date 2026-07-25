import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum CgStatus { safe, warning, unsafe }

extension CgStatusX on CgStatus {
  String get label {
    switch (this) {
      case CgStatus.safe:
        return 'SAFE';
      case CgStatus.warning:
        return 'NEAR LIMIT';
      case CgStatus.unsafe:
        return 'UNSAFE';
    }
  }

  Color get color {
    switch (this) {
      case CgStatus.safe:
        return AppColors.green;
      case CgStatus.warning:
        return AppColors.orange;
      case CgStatus.unsafe:
        return AppColors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case CgStatus.safe:
        return Icons.check_circle;
      case CgStatus.warning:
        return Icons.warning_rounded;
      case CgStatus.unsafe:
        return Icons.cancel;
    }
  }
}
