import 'dart:convert';

import '../../models/packet_model.dart';
import '../network/transport.dart';
import '../network/transport_type.dart';
import 'socket_service.dart';

class SocketTransport implements Transport {
  SocketTransport(this._service);

  final SocketService _service;

  @override
  TransportType get type => TransportType.wifiDirect;

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {
    await _service.dispose();
  }

  @override
  Future<void> send(PacketModel packet) async {
    await _service.send(
      jsonEncode(packet.toJson()),
    );
  }

  @override
  Stream<PacketModel> receive() {
    return _service.messages.map((message) {
      return PacketModel.fromJson(
        jsonDecode(message) as Map<String, dynamic>,
      );
    });
  }
}
