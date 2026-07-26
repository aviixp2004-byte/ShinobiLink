import 'package:crypto/crypto.dart';

import 'connection_coordinator.dart';
import 'connection_state.dart';
import '../network/network_manager.dart';
import '../wifi_direct/wifi_connection.dart';
import '../device/device_identity_service.dart';
import '../network/socket_handshake.dart';
import '../security/encryption_service.dart';
import '../security/key_pair_service.dart';
import '../bluetooth/handshake_model.dart';
import '../logging/app_logger.dart';

class ConnectionService {

  String _encryptionKeyId(String key) {
    return sha256
        .convert(key.codeUnits)
        .toString()
        .substring(0, 16);
  }

  ConnectionService._();

  static final ConnectionService instance =
      ConnectionService._();

  final NetworkManager networkManager =
      NetworkManager();

  final KeyPairService keyPairService =
      KeyPairService();

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
        encryptionKeyId: _encryptionKeyId(
          EncryptionService()
              .toString(),
        ),
        publicKey: keyPairService.publicKey,
      );

      await handshake.send(handshakeModel);

      _state = ConnectionState.connected;
    } catch (e, stackTrace) {
      _state = ConnectionState.failed;

      AppLogger.error(
        'Connection establishment failed',
        error: e,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> disconnect() async {
    await networkManager.stop();
    _state = ConnectionState.disconnected;
  }
}