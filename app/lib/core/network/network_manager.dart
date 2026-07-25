import '../../models/packet_model.dart';
import 'transport.dart';

class NetworkManager {
  final List<Transport> _transports = [];

  void register(Transport transport) {
    _transports.add(transport);
  }

  Future<void> startAll() async {
    for (final transport in _transports) {
      await transport.start();
    }
  }

  Future<void> stopAll() async {
    for (final transport in _transports) {
      await transport.stop();
    }
  }

  Future<void> send(PacketModel packet) async {
    for (final transport in _transports) {
      await transport.send(packet);
    }
  }
}
