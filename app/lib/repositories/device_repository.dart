import '../models/device_model.dart';

class DeviceRepository {
  final List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => List.unmodifiable(_devices);

  void addOrUpdate(DeviceModel device) {
    final index = _devices.indexWhere((d) => d.id == device.id);

    if (index == -1) {
      _devices.add(device);
    } else {
      _devices[index] = device;
    }
  }

  void remove(String id) {
    _devices.removeWhere((d) => d.id == id);
  }

  void clear() {
    _devices.clear();
  }
}
