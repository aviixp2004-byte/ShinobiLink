import 'device_identity.dart';

class DeviceIdentityService {
  DeviceIdentityService._();

  static final DeviceIdentityService instance =
      DeviceIdentityService._();

  final DeviceIdentity identity = const DeviceIdentity(
    id: 'shinobilink-device',
    name: 'ShinobiLink Device',
  );
}
