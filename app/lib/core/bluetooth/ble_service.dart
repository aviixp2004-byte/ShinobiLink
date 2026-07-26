import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../config/app_config.dart';

class BleService {
  Stream<List<ScanResult>> scanResults() {
    return FlutterBluePlus.scanResults;
  }

  Stream<BluetoothAdapterState> adapterState() {
    return FlutterBluePlus.adapterState;
  }

  Future<void> startScan() async {
    await FlutterBluePlus.startScan(
      timeout: AppConfig.discoveryInterval,
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<void> connect(BluetoothDevice device) async {
    await device.connect(
      license: License.nonprofit,
      timeout: AppConfig.handshakeTimeout,
    );
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  Future<List<BluetoothService>> discoverServices(
    BluetoothDevice device,
  ) async {
    return device.discoverServices();
  }

  Future<void> writeCharacteristic(
    BluetoothCharacteristic characteristic,
    String data,
  ) async {
    await characteristic.write(
      utf8.encode(data),
      withoutResponse: false,
    );
  }

  Future<String> readCharacteristic(
    BluetoothCharacteristic characteristic,
  ) async {
    final bytes = await characteristic.read();
    return utf8.decode(bytes);
  }

  Stream<List<int>> subscribe(
    BluetoothCharacteristic characteristic,
  ) async* {
    await characteristic.setNotifyValue(true);
    yield* characteristic.lastValueStream;
  }
}
