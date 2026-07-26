import 'dart:math';

import 'device_identity.dart';

class DeviceIdentityService {
  DeviceIdentityService._();

  static final DeviceIdentityService instance =
      DeviceIdentityService._();

  String? _encryptionKey;

  String get encryptionKey {
    _encryptionKey ??= _generateKey();
    return _encryptionKey!;
  }

  String _generateKey() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    final random = Random.secure();

    return List.generate(
      32,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }


  final DeviceIdentity identity = const DeviceIdentity(
    id: 'shinobilink-device',
    name: 'ShinobiLink Device',
  );
}
