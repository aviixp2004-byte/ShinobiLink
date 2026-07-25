import '../models/device_model.dart';

class DeviceState {
  final List<DeviceModel> devices;
  final bool isScanning;

  const DeviceState({
    this.devices = const [],
    this.isScanning = false,
  });

  DeviceState copyWith({
    List<DeviceModel>? devices,
    bool? isScanning,
  }) {
    return DeviceState(
      devices: devices ?? this.devices,
      isScanning: isScanning ?? this.isScanning,
    );
  }
}
