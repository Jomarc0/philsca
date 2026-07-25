import 'status_model.dart';

/// Aggregated weight & balance result computed from all sensor stations.
class WeightModel {
  final double totalWeightKg;
  final double totalMomentKgIn;
  final double centerOfGravityIn;
  final double forwardLimitIn;
  final double aftLimitIn;

  const WeightModel({
    required this.totalWeightKg,
    required this.totalMomentKgIn,
    required this.centerOfGravityIn,
    this.forwardLimitIn = 31.0,
    this.aftLimitIn = 36.0,
  });

  /// Distance (in) from the nearest limit boundary. Used to detect
  /// "approaching limits" (NEAR LIMIT / WARNING) state.
  double get marginToNearestLimit {
    final marginForward = centerOfGravityIn - forwardLimitIn;
    final marginAft = aftLimitIn - centerOfGravityIn;
    return marginForward < marginAft ? marginForward : marginAft;
  }

  CgStatus get status {
    if (centerOfGravityIn < forwardLimitIn || centerOfGravityIn > aftLimitIn) {
      return CgStatus.unsafe;
    }
    // Within 1.0 inch of either limit counts as approaching / near limit.
    if (marginToNearestLimit <= 1.0) {
      return CgStatus.warning;
    }
    return CgStatus.safe;
  }

  /// Normalized position (0.0 - 1.0) of the CG between forward and aft
  /// limits, useful for driving the animated marker in the CG visualizer.
  double get normalizedPosition {
    final range = aftLimitIn - forwardLimitIn;
    if (range <= 0) return 0.5;
    final pos = (centerOfGravityIn - forwardLimitIn) / range;
    return pos.clamp(0.0, 1.0);
  }

  factory WeightModel.empty() => const WeightModel(
        totalWeightKg: 0,
        totalMomentKgIn: 0,
        centerOfGravityIn: 0,
      );
}
