import 'status_model.dart';

/// A single saved weight & balance calculation record shown in History.
class HistoryModel {
  final String id;
  final DateTime timestamp;
  final double totalWeightKg;
  final double centerOfGravityIn;
  final CgStatus status;

  const HistoryModel({
    required this.id,
    required this.timestamp,
    required this.totalWeightKg,
    required this.centerOfGravityIn,
    required this.status,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      totalWeightKg: (json['totalWeightKg'] as num).toDouble(),
      centerOfGravityIn: (json['centerOfGravityIn'] as num).toDouble(),
      status: CgStatus.values[json['status'] as int],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'totalWeightKg': totalWeightKg,
        'centerOfGravityIn': centerOfGravityIn,
        'status': status.index,
      };
}
