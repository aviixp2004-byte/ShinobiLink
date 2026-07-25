import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

import 'ble_service.dart';

class BleController {
  final BleService _bleService = BleService();
  final Logger _logger = Logger();

  StreamSubscription<List<ScanResult>>? _subscription;

  void startScanning() {
    _subscription = _bleService.scanResults().listen((results) {
      for (final result in results) {
        _logger.i(
          'Found: ${result.device.platformName} (${result.device.remoteId})',
        );
      }
    });

    _bleService.startScan();
  }

  void stopScanning() {
    _subscription?.cancel();
    _bleService.stopScan();
  }
}
