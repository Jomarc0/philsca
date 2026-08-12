import 'package:flutter/material.dart';
import '../models/aircraft_model.dart';
import '../models/sensor_model.dart';
import '../models/weight_model.dart';
import '../services/cg_calculator_service.dart';

/// Central provider holding sensor readings and the derived
/// weight & balance calculation. Dashboard, Live Monitoring,
/// CG Visualizer, and Weight Distribution all read from this single
/// source of truth so numbers stay consistent across screens.
class CgProvider extends ChangeNotifier {
  CgProvider({CgCalculatorService? calculator})
      : _calculator = calculator ?? const CgCalculatorService() {
    _recalculate();
  }

  final CgCalculatorService _calculator;

  final AircraftModel aircraft = AircraftModel.cessna172;

  List<SensorModel> _sensors = [
    const SensorModel(
      id: 'pilot',
      stationName: 'Pilot',
      description: 'Front Left',
      weightKg: 0,
      armIn: 30.0,
      icon: Icons.person,
    ),
    const SensorModel(
      id: 'passenger',
      stationName: 'Passenger',
      description: 'Front Right',
      weightKg: 0,
      armIn: 30.0,
      icon: Icons.person_outline,
    ),
    const SensorModel(
      id: 'rear_passenger',
      stationName: 'Rear Passenger',
      description: 'Rear Seats',
      weightKg: 0,
      armIn: 34.0,
      icon: Icons.people_alt_outlined,
    ),
    const SensorModel(
      id: 'cargo',
      stationName: 'Cargo',
      description: 'Baggage Area',
      weightKg: 0,
      armIn: 35.0,
      icon: Icons.inventory_2_outlined,
    ),
    const SensorModel(
      id: 'fuel',
      stationName: 'Fuel',
      description: 'Fuel Tank',
      weightKg: 0,
      armIn: 32.0,
      icon: Icons.local_gas_station_outlined,
    ),
    const SensorModel(
      id: 'baggage',
      stationName: 'Baggage',
      description: 'Rear Compartment',
      weightKg: 0,
      armIn: 38.0,
      icon: Icons.work_outline,
    ),
  ];

  WeightModel _result = WeightModel.empty();

  List<SensorModel> get sensors => List.unmodifiable(_sensors);
  WeightModel get result => _result;

  void _recalculate() {
    _result = _calculator.calculate(
      _sensors,
      forwardLimitIn: aircraft.forwardCgLimitIn,
      aftLimitIn: aircraft.aftCgLimitIn,
    );
  }

  void updateSensorWeight(String sensorId, double newWeightKg) {
    _sensors = _sensors
        .map((s) => s.id == sensorId ? s.copyWith(weightKg: newWeightKg) : s)
        .toList();
    _recalculate();
    notifyListeners();
  }

  /// Simulates a refresh from the live device (small random jitter),
  /// standing in for real BLE sensor updates.
  Future<void> refreshFromDevice() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _recalculate();
    notifyListeners();
  }
}
