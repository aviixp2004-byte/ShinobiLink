import 'handshake_model.dart';

class HandshakeService {
  const HandshakeService();

  String create({
    required String deviceId,
    required String deviceName,
    required String ip,
    required int port,
    required bool isServer,
  }) {
    return HandshakeModel(
      deviceId: deviceId,
      deviceName: deviceName,
      ip: ip,
      port: port,
      role: isServer ? 'server' : 'client',
    ).encode();
  }

  HandshakeModel parse(String payload) {
    return HandshakeModel.decode(payload);
  }
}
