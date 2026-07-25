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
              port: 9000,
            );

  SocketTransport _transport;

  Future<void> start() async {
    await _transport.start();
  }

  Future<void> stop() async {
    await _transport.stop();
  }

  Future<void> startServer({
    int port = 9000,
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
    int port = 9000,
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

  Future<void> send(PacketModel packet) async {
    await _transport.send(packet);
  }

  Stream<PacketModel> receive() {
    return _transport.receive();
  }
}
