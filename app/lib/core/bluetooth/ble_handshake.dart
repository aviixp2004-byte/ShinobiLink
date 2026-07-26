import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../exceptions/app_exception.dart';
import 'ble_service.dart';
import 'handshake_model.dart';
import 'handshake_service.dart';

class BleHandshake {
  BleHandshake({
    required this.bleService,
    required this.handshakeService,
  });

  final BleService bleService;
  final HandshakeService handshakeService;

  static final Guid serviceUuid =
      Guid("12345678-1234-5678-1234-56789abcdef0");

  static final Guid characteristicUuid =
      Guid("87654321-4321-8765-4321-fedcba987654");

  Future<BluetoothCharacteristic> characteristic(
    BluetoothDevice device,
  ) async {
    final services = await bleService.discoverServices(device);

    for (final service in services) {
      if (service.uuid == serviceUuid) {
        for (final c in service.characteristics) {
          if (c.uuid == characteristicUuid) {
            return c;
          }
        }
      }
    }

    throw HandshakeException('Handshake characteristic not found');
  }

  Future<void> send(
    BluetoothDevice device,
    HandshakeModel handshake,
  ) async {
    final c = await characteristic(device);

    await bleService.writeCharacteristic(
      c,
      handshake.encode(),
    );
  }

  Future<HandshakeModel> receive(
    BluetoothDevice device,
  ) async {
    final c = await characteristic(device);

    final payload = await bleService.readCharacteristic(c);

    return handshakeService.parse(payload);
  }
}
