import 'package:shinobilink/core/config/network_config.dart';
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/socket/socket_mode.dart';
import '../../core/socket/socket_service.dart';
import '../../core/socket/socket_transport.dart';

class SocketTestScreen extends StatefulWidget {
  const SocketTestScreen({super.key});

  @override
  State<SocketTestScreen> createState() => _SocketTestScreenState();
}

class _SocketTestScreenState extends State<SocketTestScreen> {
  final ipController = TextEditingController();
  final messageController = TextEditingController();

  final SocketService _service = SocketService();

  late SocketTransport _transport;

  final List<String> _messages = [];

  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    _service.dispose();
    ipController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _startServer() async {
    _transport = SocketTransport(
      _service,
      mode: SocketMode.server,
      port: NetworkConfig.transferPort,
    );

    await _transport.start();

    _listen();

    _add("Server started on port NetworkConfig.transferPort");
  }

  Future<void> _connect() async {
    _transport = SocketTransport(
      _service,
      mode: SocketMode.client,
      host: ipController.text.trim(),
      port: NetworkConfig.transferPort,
    );

    await _transport.start();

    _listen();

    _add("Connected");
  }

  void _listen() {
    _subscription?.cancel();

    _subscription = _service.messages.listen((message) {
      _add("Peer: $message");
    });
  }

  Future<void> _send() async {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    await _service.send(text);

    _add("Me: $text");

    messageController.clear();
  }

  void _add(String value) {
    if (!mounted) return;

    setState(() {
      _messages.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Socket Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: "Server IP",
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _startServer,
                    child: const Text("Start Server"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _connect,
                    child: const Text("Connect"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: "Message",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _send,
              child: const Text("Send"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
