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

  List<MessageModel> get messages => List.unmodifiable(_messages);

  Future<void> send(MessageModel message) async {
    _messages.add(message);

    final packet = chatEngine.messageToPacket(message);

    await networkManager.send(packet);
  }

  void receive(MessageModel message) {
    _messages.add(message);
  }

  void clear() {
    _messages.clear();
  }
}
