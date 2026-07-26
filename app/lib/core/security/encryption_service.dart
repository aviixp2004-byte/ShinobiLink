
import 'package:encrypt/encrypt.dart';

class EncryptionService {

  late Key _key;
  late Encrypter _encrypter;

  final IV _iv = IV.fromLength(16);


  EncryptionService({
    String? sessionKey,
  }) {

    _initialize(
      sessionKey ??
          Key.fromLength(32).base64,
    );
  }


  void _initialize(String keyValue) {

    _key = Key.fromBase64(
      keyValue,
    );

    _encrypter = Encrypter(
      AES(_key),
    );
  }


  void updateSessionKey(
    String sessionKey,
  ) {

    _initialize(
      Key.fromUtf8(
        sessionKey
            .padRight(32)
            .substring(0, 32),
      ).base64,
    );
  }


  String encrypt(String text) {

    return _encrypter.encrypt(
      text,
      iv: _iv,
    ).base64;
  }


  String decrypt(String encrypted) {

    return _encrypter.decrypt64(
      encrypted,
      iv: _iv,
    );
  }
}
