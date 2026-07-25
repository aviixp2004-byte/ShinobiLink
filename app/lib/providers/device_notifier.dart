import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_state.dart';

class DeviceNotifier extends Notifier<DeviceState> {
  @override
  DeviceState build() {
    return const DeviceState();
  }

  void startScanning() {
    state = state.copyWith(isScanning: true);
  }

  void stopScanning() {
    state = state.copyWith(isScanning: false);
  }
}
