import 'connection_coordinator.dart';
import 'connection_state.dart';
import '../network/network_manager.dart';
import '../wifi_direct/wifi_connection.dart';
import '../device/device_identity_service.dart';
import '../network/socket_handshake.dart';
import '../bluetooth/handshake_model.dart';

class ConnectionService {
  ConnectionService._();

  static final ConnectionService instance =
      ConnectionService._();

  final NetworkManager networkManager =
      NetworkManager();

  late final SocketHandshake handshake =
      SocketHandshake(networkManager);

  late final ConnectionCoordinator coordinator =
      ConnectionCoordinator(
        networkManager: networkManager,
      );

  ConnectionState _state = ConnectionState.idle;

  ConnectionState get state => _state;

  Future<void> connectWifi(
    WifiConnection connection,
  ) async {
    try {
      _state = ConnectionState.connecting;

      await coordinator.establishWifiConnection(
        connection,
      );

      final identity =
          DeviceIdentityService.instance.identity;

      final handshakeModel = HandshakeModel(
        deviceId: identity.id,
        deviceName: identity.name,
        ip: connection.ip,
        port: connection.port,
        role: connection.isHost
            ? 'server'
            : 'client',
      );

      await handshake.send(handshakeModel);

      _state = ConnectionState.connected;
    } catch (_) {
      _state = ConnectionState.failed;
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await networkManager.stop();
    _state = ConnectionState.disconnected;
  }
}
