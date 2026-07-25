import '../network/network_manager.dart';
import 'connection_coordinator.dart';

class ConnectionService {
  ConnectionService._();

  static final ConnectionService instance =
      ConnectionService._();

  final NetworkManager networkManager =
      NetworkManager();

  late final ConnectionCoordinator coordinator =
      ConnectionCoordinator(
        networkManager: networkManager,
      );
}
