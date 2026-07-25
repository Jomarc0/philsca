import 'dart:math';
import '../models/history_model.dart';
import '../models/status_model.dart';
import 'storage_service.dart';

/// Handles reading, writing, and generating history records.
class HistoryService {
  HistoryService({StorageService? storageService})
      : _storage = storageService ?? StorageService();

  final StorageService _storage;

  Future<List<HistoryModel>> loadHistory() async {
    final raw = await _storage.readHistory();
    if (raw.isEmpty) {
      final mock = generateMockHistory();
      await persist(mock);
      return mock;
    }
    return raw.map(HistoryModel.fromJson).toList();
  }

  Future<void> persist(List<HistoryModel> records) async {
    await _storage.saveHistory(records.map((r) => r.toJson()).toList());
  }

  Future<List<HistoryModel>> addRecord(
    List<HistoryModel> current,
    HistoryModel record,
  ) async {
    final updated = [record, ...current];
    await persist(updated);
    return updated;
  }

  /// Generates at least 20 mock history records for demo purposes.
  List<HistoryModel> generateMockHistory({int count = 24}) {
    final random = Random(42);
    final now = DateTime.now();
    final records = <HistoryModel>[];

    for (int i = 0; i < count; i++) {
      final date = now.subtract(Duration(days: i, hours: random.nextInt(6)));
      final weight = 480 + random.nextInt(160).toDouble();
      final cg = 30.5 + random.nextDouble() * 6.5;

      CgStatus status;
      if (cg < 31.0 || cg > 36.0) {
        status = CgStatus.unsafe;
      } else if (cg - 31.0 <= 1.0 || 36.0 - cg <= 1.0) {
        status = CgStatus.warning;
      } else {
        status = CgStatus.safe;
      }

      records.add(
        HistoryModel(
          id: 'hist_$i',
          timestamp: date,
          totalWeightKg: double.parse(weight.toStringAsFixed(0)),
          centerOfGravityIn: double.parse(cg.toStringAsFixed(1)),
          status: status,
        ),
      );
    }

    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }
}
