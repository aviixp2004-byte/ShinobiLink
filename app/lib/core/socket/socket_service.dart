import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'transport_state.dart';

class SocketService {
  ServerSocket? _server;
  Socket? _socket;

  final _incoming = StreamController<String>.broadcast();

  final _stateController =
      StreamController<TransportState>.broadcast();

  Stream<TransportState> get state =>
      _stateController.stream;

  void _emit(TransportState state) {
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  Stream<String> get messages => _incoming.stream;

  Future<void> startServer(int port) async {
    _emit(TransportState.starting);
    _server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      port,
    );

    _server!.listen((client) {
      _socket = client;

      _emit(TransportState.connected);

      client
          .cast<List<int>>()
          .transform(utf8.decoder)
          .listen(
        (message) {
          _incoming.add(message);
        },
        onDone: () => _emit(TransportState.disconnected),
        onError: (_) => _emit(TransportState.error),
      );
    });
  }

  Future<void> connect(

    String host,
    int port,
  ) async {
    _emit(TransportState.starting);

    _socket = await Socket.connect(host, port);

    _emit(TransportState.connected);

    _socket!
        .cast<List<int>>()
        .transform(utf8.decoder)
        .listen(
      (message) {
        _incoming.add(message);
      },
      onDone: () => _emit(TransportState.disconnected),
      onError: (_) => _emit(TransportState.error),
    )
  }

  Future<void> send(String message) async {
    _socket?.writeln(message);
  }

  Future<void> dispose() async {
    await _socket?.close();
    await _server?.close();
    await _incoming.close();
    await _stateController.close();
  }
}
