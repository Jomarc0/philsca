import 'dart:async';
import 'package:flutter/foundation.dart';

/// Connection state for the physical ESP32 device.
enum DeviceConnectionState { disconnected, scanning, connecting, connected }

/// Architecture-only Bluetooth service.
///
/// This does NOT connect to real hardware yet. It exposes the same
/// surface area (streams + ChangeNotifier) that a real
/// `flutter_blue_plus`-backed implementation would use, so the rest
/// of the app (providers/UI) can be wired up now and the real ESP32
/// integration can be dropped in later without touching UI code.
class BluetoothDeviceService extends ChangeNotifier {
  DeviceConnectionState _connectionState = DeviceConnectionState.connected;
  int _batteryPercent = 90;
  String _deviceId = 'PCG-DEVICE-01';

  final StreamController<Map<String, double>> _sensorStreamController =
      StreamController<Map<String, double>>.broadcast();

  DeviceConnectionState get connectionState => _connectionState;
  bool get isConnected => _connectionState == DeviceConnectionState.connected;
  int get batteryPercent => _batteryPercent;
  String get deviceId => _deviceId;

  /// Live stream of sensor readings keyed by sensor id.
  /// A real implementation will feed this from BLE characteristic
  /// notifications coming from the ESP32.
  Stream<Map<String, double>> get sensorStream => _sensorStreamController.stream;

  Future<void> connect() async {
    _connectionState = DeviceConnectionState.scanning;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _connectionState = DeviceConnectionState.connecting;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _connectionState = DeviceConnectionState.connected;
    notifyListeners();
  }

  Future<void> disconnect() async {
    _connectionState = DeviceConnectionState.disconnected;
    notifyListeners();
  }

  /// Pushes a mock/simulated sensor reading update through the stream.
  /// Replace call-sites with real BLE characteristic parsing later.
  void emitReading(Map<String, double> reading) {
    _sensorStreamController.add(reading);
  }

  @override
  void dispose() {
    _sensorStreamController.close();
    super.dispose();
  }
}
