import 'package:flutter/foundation.dart';
import '../models/history_model.dart';
import '../models/status_model.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider({HistoryService? service})
      : _service = service ?? HistoryService() {
    loadHistory();
  }

  final HistoryService _service;

  List<HistoryModel> _records = [];
  bool _isLoading = false;
  String _query = '';

  bool get isLoading => _isLoading;
  String get query => _query;

  List<HistoryModel> get records {
    if (_query.trim().isEmpty) return List.unmodifiable(_records);
    final q = _query.toLowerCase();
    return _records
        .where((r) =>
            r.status.label.toLowerCase().contains(q) ||
            r.totalWeightKg.toString().contains(q) ||
            r.centerOfGravityIn.toString().contains(q))
        .toList();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    _records = await _service.loadHistory();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadHistory();

  void search(String value) {
    _query = value;
    notifyListeners();
  }
}
