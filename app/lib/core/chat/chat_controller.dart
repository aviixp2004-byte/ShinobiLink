import '../../models/message_model.dart';
import '../../repositories/chat_repository.dart';

class ChatController {
  ChatController(this._repository);

  final ChatRepository _repository;

  List<MessageModel> get messages => _repository.messages;

  Stream<List<MessageModel>> get messagesStream =>
      _repository.messagesStream;

  Future<void> start() async {
    await _repository.startListening();
  }

  Future<void> stop() async {
    await _repository.stopListening();
  }

  Future<void> send(MessageModel message) async {
    await _repository.send(message);
  }

  void receive(MessageModel message) {
    _repository.receive(message);
  }

  void clear() {
    _repository.clear();
  }

  Future<void> dispose() async {
    await _repository.dispose();
  }
}
