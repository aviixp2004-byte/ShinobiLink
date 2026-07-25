import 'dart:convert';

import '../../models/packet_model.dart';
import '../network/transport.dart';
import '../network/transport_type.dart';
import 'socket_mode.dart';
import 'socket_service.dart';

class SocketTransport implements Transport {
  SocketTransport(
    this._service, {
    required this.mode,
    required this.port,
    this.host,
  });

  final SocketService _service;

  final SocketMode mode;
  final String? host;
  final int port;

  @override
  TransportType get type => TransportType.wifiDirect;

  @override
  Future<void> start() async {
    switch (mode) {
      case SocketMode.server:
        await _service.startServer(port);
        break;

      case SocketMode.client:
        if (host == null || host!.isEmpty) {
          throw Exception('Host is required in client mode.');
        }

        await _service.connect(host!, port);
        break;
    }
  }

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

  Future<void> sendRaw(String data) async {
    await _service.send(data);
  }

  Stream<String> receiveRaw() {
    return _service.messages;
  }

  @override
  Stream<PacketModel> receive() {
    return _service.messages.map(
      (message) => PacketModel.fromJson(
        jsonDecode(message) as Map<String, dynamic>,
      ),
    );
  }
}
