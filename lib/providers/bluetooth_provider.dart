import 'package:flutter/foundation.dart';
import '../services/bluetooth_service.dart';

class BluetoothProvider extends ChangeNotifier {
  BluetoothProvider({BluetoothDeviceService? service})
      : _service = service ?? BluetoothDeviceService() {
    _service.addListener(notifyListeners);
  }

  final BluetoothDeviceService _service;

  bool get isConnected => _service.isConnected;
  DeviceConnectionState get connectionState => _service.connectionState;
  int get batteryPercent => _service.batteryPercent;
  String get deviceId => _service.deviceId;

  Future<void> connect() => _service.connect();
  Future<void> disconnect() => _service.disconnect();

  @override
  void dispose() {
    _service.removeListener(notifyListeners);
    super.dispose();
  }
}
