import 'package:shinobilink/core/config/network_config.dart';
import '../../models/packet_model.dart';
import '../socket/socket_mode.dart';
import '../socket/socket_service.dart';
import '../socket/socket_transport.dart';

class NetworkManager {
  NetworkManager({
    SocketTransport? transport,
  }) : _transport =
            transport ??
            SocketTransport(
              SocketService(),
              mode: SocketMode.server,
              port: NetworkConfig.transferPort,
            );

  SocketTransport _transport;

  Future<void> start() async {
    await _transport.start();
  }

  Future<void> stop() async {
    await _transport.stop();
  }

  Future<void> startServer({
    int port = NetworkConfig.transferPort,
  }) async {
    await _transport.stop();

    _transport = SocketTransport(
      SocketService(),
      mode: SocketMode.server,
      port: port,
    );

    await _transport.start();
  }

  Future<void> connect({
    required String host,
    int port = NetworkConfig.transferPort,
  }) async {
    await _transport.stop();

    _transport = SocketTransport(
      SocketService(),
      mode: SocketMode.client,
      host: host,
      port: port,
    );

    await _transport.start();
  }

  Future<void> sendRaw(String data) async {
    await _transport.sendRaw(data);
  }

  Stream<String> receiveRaw() {
    return _transport.receiveRaw();
  }

  Future<void> send(PacketModel packet) async {
    await _transport.send(packet);
  }

  Stream<PacketModel> receive() {
    return _transport.receive();
  }
}
