
import 'dart:convert';

import 'package:crypto/crypto.dart';

class SharedSecretService {


  String derive({
    required String privateKey,
    required String peerPublicKey,
  }) {

    final combined =
        '$privateKey:$peerPublicKey';

    return sha256
        .convert(
          utf8.encode(combined),
        )
        .toString();
  }


  String createSessionKey({
    required String sharedSecret,
  }) {

    return sha256
        .convert(
          utf8.encode(sharedSecret),
        )
        .toString()
        .substring(0, 32);
  }

}
