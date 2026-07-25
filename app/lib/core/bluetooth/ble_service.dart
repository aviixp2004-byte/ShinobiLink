import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  Stream<List<ScanResult>> scanResults() {
    return FlutterBluePlus.scanResults;
  }

  Stream<BluetoothAdapterState> adapterState() {
    return FlutterBluePlus.adapterState;
  }

  Future<void> startScan() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<void> connect(BluetoothDevice device) async {
    await device.connect(
      license: License.nonprofit,
      timeout: const Duration(seconds: 10),
    );
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }
}
