import 'package:flutter/material.dart';

/// Represents a single weight sensor/station on the aircraft
/// (e.g. Pilot, Passenger, Cargo, Fuel, Baggage).
class SensorModel {
  final String id;
  final String stationName;
  final String description;
  final double weightKg;
  final double armIn;
  final IconData icon;
  final bool isOnline;

  const SensorModel({
    required this.id,
    required this.stationName,
    required this.description,
    required this.weightKg,
    required this.armIn,
    required this.icon,
    this.isOnline = true,
  });

  /// Moment = Weight × Arm
  double get momentKgIn => weightKg * armIn;

  SensorModel copyWith({
    double? weightKg,
    double? armIn,
    bool? isOnline,
  }) {
    return SensorModel(
      id: id,
      stationName: stationName,
      description: description,
      weightKg: weightKg ?? this.weightKg,
      armIn: armIn ?? this.armIn,
      icon: icon,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  factory SensorModel.fromJson(Map<String, dynamic> json, IconData icon) {
    return SensorModel(
      id: json['id'] as String,
      stationName: json['stationName'] as String,
      description: json['description'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      armIn: (json['armIn'] as num).toDouble(),
      icon: icon,
      isOnline: json['isOnline'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'stationName': stationName,
        'description': description,
        'weightKg': weightKg,
        'armIn': armIn,
        'isOnline': isOnline,
      };
}
