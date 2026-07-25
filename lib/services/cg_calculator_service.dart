import '../models/sensor_model.dart';
import '../models/weight_model.dart';

/// Pure calculation service. Contains no UI or state — just the
/// weight & balance math, so it is trivially unit-testable.
///
/// Formulas:
///   Moment = Weight x Arm
///   CG     = Total Moment / Total Weight
class CgCalculatorService {
  const CgCalculatorService();

  WeightModel calculate(
    List<SensorModel> sensors, {
    double forwardLimitIn = 31.0,
    double aftLimitIn = 36.0,
  }) {
    if (sensors.isEmpty) return WeightModel.empty();

    final totalWeight = sensors.fold<double>(0, (sum, s) => sum + s.weightKg);
    final totalMoment = sensors.fold<double>(0, (sum, s) => sum + s.momentKgIn);

    final cg = totalWeight == 0 ? 0.0 : totalMoment / totalWeight;

    return WeightModel(
      totalWeightKg: totalWeight,
      totalMomentKgIn: totalMoment,
      centerOfGravityIn: double.parse(cg.toStringAsFixed(1)),
      forwardLimitIn: forwardLimitIn,
      aftLimitIn: aftLimitIn,
    );
  }
}
