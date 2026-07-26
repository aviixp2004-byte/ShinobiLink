
import 'dart:math';

import '../services/storage_service.dart';

class KeyPairService {

  static const _privateKeyBox =
      'private_key';

  static const _publicKeyBox =
      'public_key';


  String get privateKey {

    final stored =
        StorageService.box.get(
          _privateKeyBox,
        );

    if (stored != null) {
      return stored;
    }

    final key = _generateKey();

    StorageService.box.put(
      _privateKeyBox,
      key,
    );

    return key;
  }


  String get publicKey {

    final stored =
        StorageService.box.get(
          _publicKeyBox,
        );

    if (stored != null) {
      return stored;
    }

    final key = _generateKey();

    StorageService.box.put(
      _publicKeyBox,
      key,
    );

    return key;
  }


  String _generateKey() {

    const chars =
        'abcdefghijklmnopqrstuvwxyz'
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        '0123456789';

    final random =
        Random.secure();

    return List.generate(
      64,
      (_) =>
          chars[random.nextInt(
            chars.length,
          )],
    ).join();
  }
}
