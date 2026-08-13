import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Connection state for the physical ESP32 device.
enum DeviceConnectionState { disconnected, scanning, connecting, connected }

/// Real BLE service for the ESP32 weight & balance device.
///
/// Update [targetDeviceName], [serviceUuid], and [characteristicUuid]
/// to match the identifiers advertised by your board.
class BluetoothDeviceService extends ChangeNotifier {
  BluetoothDeviceService({
    this.targetDeviceName = 'PCG-DEVICE',
    this.serviceUuid,
    this.characteristicUuid,
  });

  final String targetDeviceName;
  final Guid? serviceUuid;
  final Guid? characteristicUuid;

  DeviceConnectionState _connectionState = DeviceConnectionState.disconnected;
  int _batteryPercent = 0;
  String _deviceId = '';

  BluetoothDevice? _device;
  BluetoothCharacteristic? _notifyCharacteristic;
  StreamSubscription<List<ScanResult>>? _scanResultsSub;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSub;
  StreamSubscription<List<int>>? _notifySub;
  final StreamController<Map<String, double>> _sensorStreamController =
      StreamController<Map<String, double>>.broadcast();

  DeviceConnectionState get connectionState => _connectionState;
  bool get isConnected => _connectionState == DeviceConnectionState.connected;
  int get batteryPercent => _batteryPercent;
  String get deviceId => _deviceId;
  Stream<Map<String, double>> get sensorStream => _sensorStreamController.stream;

  Future<void> connect() async {
    if (_connectionState == DeviceConnectionState.connected) return;

    _setState(DeviceConnectionState.scanning);

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 8),
      withServices: serviceUuid == null ? <Guid>[] : [serviceUuid!],
    );

    final scanResults = await FlutterBluePlus.scanResults.first;
    await FlutterBluePlus.stopScan();

    BluetoothDevice? matched;
    for (final result in scanResults) {
      final name = result.device.platformName;
      if (name.isNotEmpty && name.contains(targetDeviceName)) {
        matched = result.device;
        break;
      }
    }

    if (matched == null) {
      _setState(DeviceConnectionState.disconnected);
      throw Exception('No BLE device found matching "$targetDeviceName".');
    }

    _device = matched;
    _deviceId = _device!.remoteId.str;
    _setState(DeviceConnectionState.connecting);

    _connectionStateSub?.cancel();
    _connectionStateSub = _device!.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _cleanupConnection();
        _setState(DeviceConnectionState.disconnected);
      }
    });

    await _device!.connect(timeout: const Duration(seconds: 12));
    await _discoverAndSubscribe();
    _batteryPercent = 100;
    _setState(DeviceConnectionState.connected);
  }

  Future<void> disconnect() async {
    await _notifySub?.cancel();
    _notifySub = null;
    await _connectionStateSub?.cancel();
    _connectionStateSub = null;

    final device = _device;
    _device = null;
    _notifyCharacteristic = null;
    _deviceId = '';
    _batteryPercent = 0;

    if (device != null) {
      try {
        await device.disconnect();
      } catch (_) {
        // Ignore disconnect errors; the device may already be gone.
      }
    }

    _setState(DeviceConnectionState.disconnected);
  }

  Future<void> _discoverAndSubscribe() async {
    final device = _device;
    if (device == null) return;

    final services = await device.discoverServices();
    BluetoothService? targetService;
    for (final service in services) {
      if (serviceUuid == null || service.uuid == serviceUuid) {
        targetService = service;
        break;
      }
    }

    if (targetService == null) {
      return;
    }

    BluetoothCharacteristic? targetChar;
    for (final characteristic in targetService.characteristics) {
      if (characteristicUuid == null || characteristic.uuid == characteristicUuid) {
        targetChar = characteristic;
        break;
      }
    }

    if (targetChar == null) {
      return;
    }

    _notifyCharacteristic = targetChar;

    if (targetChar.properties.notify) {
      await targetChar.setNotifyValue(true);
      await _notifySub?.cancel();
      _notifySub = targetChar.lastValueStream.listen(_handleNotification);
    }
  }

  void _handleNotification(List<int> bytes) {
    final payload = String.fromCharCodes(bytes).trim();
    final values = <String, double>{};

    for (final part in payload.split(',')) {
      final entry = part.split(':');
      if (entry.length != 2) continue;
      final key = entry[0].trim();
      final value = double.tryParse(entry[1].trim());
      if (value != null) {
        values[key] = value;
      }
    }

    if (values.isNotEmpty) {
      _sensorStreamController.add(values);
    }
  }

  void _cleanupConnection() {
    _notifySub?.cancel();
    _notifySub = null;
    _notifyCharacteristic = null;
    _device = null;
    _deviceId = '';
    _batteryPercent = 0;
  }

  void _setState(DeviceConnectionState state) {
    _connectionState = state;
    notifyListeners();
  }

  /// Manual test helper for simulating payloads during development.
  void emitReading(Map<String, double> reading) {
    _sensorStreamController.add(reading);
  }

  @override
  void dispose() {
    _notifySub?.cancel();
    _connectionStateSub?.cancel();
    _scanResultsSub?.cancel();
    _sensorStreamController.close();
    super.dispose();
  }
}
