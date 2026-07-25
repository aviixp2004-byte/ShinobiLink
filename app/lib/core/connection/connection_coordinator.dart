import '../bluetooth/handshake_model.dart';
import '../network/network_manager.dart';
import '../wifi_direct/wifi_connection.dart';

class ConnectionCoordinator {
  ConnectionCoordinator({
    required this.networkManager,
  });

  final NetworkManager networkManager;

  Future<void> establish(HandshakeModel peer) async {
    if (peer.role == 'server') {
      await networkManager.connect(
        host: peer.ip,
        port: peer.port,
      );
    } else {
      await networkManager.startServer(
        port: peer.port,
      );
    }
  }

  Future<void> establishWifiConnection(
    WifiConnection connection,
  ) async {
    if (connection.isHost) {
      await networkManager.startServer(
        port: connection.port,
      );
    } else {
      await networkManager.connect(
        host: connection.ip,
        port: connection.port,
      );
    }
  }
}
