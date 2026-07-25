import 'package:flutter/foundation.dart';

/// Holds simple dashboard-level UI state (currently minimal, but kept
/// separate per clean architecture so dashboard-specific state doesn't
/// leak into CgProvider as the app grows — e.g. dismissible banners,
/// last-synced timestamps, etc).
class DashboardProvider extends ChangeNotifier {
  DateTime? _lastSyncedAt = DateTime.now();

  DateTime? get lastSyncedAt => _lastSyncedAt;

  void markSynced() {
    _lastSyncedAt = DateTime.now();
    notifyListeners();
  }
}
