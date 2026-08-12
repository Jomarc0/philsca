import '../models/history_model.dart';
import 'storage_service.dart';

/// Handles reading and writing history records.
class HistoryService {
  HistoryService({StorageService? storageService})
      : _storage = storageService ?? StorageService();

  final StorageService _storage;

  Future<List<HistoryModel>> loadHistory() async {
    final raw = await _storage.readHistory();
    final records = raw.map(HistoryModel.fromJson).toList();
    final cleaned = records.where((r) => !r.id.startsWith('hist_')).toList();
    if (cleaned.length != records.length) {
      await persist(cleaned);
    }
    return cleaned;
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
}
