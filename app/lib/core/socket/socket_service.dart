import 'dart:async';
import 'dart:convert';
import 'dart:io';

class SocketService {
  ServerSocket? _server;
  Socket? _socket;

  final _incoming = StreamController<String>.broadcast();

  Stream<String> get messages => _incoming.stream;

  Future<void> startServer(int port) async {
    _server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      port,
    );

    _server!.listen((client) {
      _socket = client;

      client
          .cast<List<int>>()
          .transform(utf8.decoder)
          .listen((message) {
        _incoming.add(message);
      });
    });
  }

  Future<void> connect(
    String host,
    int port,
  ) async {
    _socket = await Socket.connect(host, port);

    _socket!
        .cast<List<int>>()
        .transform(utf8.decoder)
        .listen((message) {
      _incoming.add(message);
    });
  }

  Future<void> send(String message) async {
    _socket?.writeln(message);
  }

  Future<void> dispose() async {
    await _socket?.close();
    await _server?.close();
    await _incoming.close();
  }
}
