import '../bluetooth/handshake_model.dart';
import 'network_manager.dart';

class SocketHandshake {
  SocketHandshake(this.networkManager);

  final NetworkManager networkManager;

  Future<void> send(HandshakeModel handshake) async {
    await networkManager.sendRaw(
      handshake.encode(),
    );
  }

  Stream<HandshakeModel> receive() {
    return networkManager
        .receiveRaw()
        .map(
          (data) => HandshakeModel.decode(data),
        );
  }

  Future<HandshakeModel> waitForHandshake() async {
    final payload =
        await networkManager.receiveRaw().first;

    return HandshakeModel.decode(payload);
  }
}
