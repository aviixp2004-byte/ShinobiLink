import 'dart:async';

import '../core/chat/chat_engine.dart';
import '../core/network/network_manager.dart';
import '../models/message_model.dart';

class ChatRepository {
  ChatRepository({
    required this.networkManager,
    required this.chatEngine,
  });

  final NetworkManager networkManager;
  final ChatEngine chatEngine;

  final List<MessageModel> _messages = [];

  final StreamController<List<MessageModel>> _messagesController =
      StreamController<List<MessageModel>>.broadcast();

  StreamSubscription? _subscription;

  List<MessageModel> get messages => List.unmodifiable(_messages);

  Stream<List<MessageModel>> get messagesStream =>
      _messagesController.stream;

  void _notify() {
    _messagesController.add(List.unmodifiable(_messages));
  }

  Future<void> startListening() async {
    await _subscription?.cancel();

    _subscription = networkManager.receive().listen((packet) {
      final message = chatEngine.packetToMessage(packet);
      _messages.add(message);
      _notify();
    });
  }

  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> send(MessageModel message) async {
    _messages.add(message);
    _notify();

    final packet = chatEngine.messageToPacket(message);

    await networkManager.send(packet);
  }

  void receive(MessageModel message) {
    _messages.add(message);
    _notify();
  }

  void clear() {
    _messages.clear();
    _notify();
  }

  Future<void> dispose() async {
    await stopListening();
    await _messagesController.close();
  }
}
