import '../../models/message_model.dart';
import '../../repositories/chat_repository.dart';

class ChatController {

  MessageModel? _replyingTo;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void setSearchQuery(String value) {
    _searchQuery = value;
  }

  void clearSearch() {
    _searchQuery = '';
  }


  MessageModel? get replyingTo => _replyingTo;

  void startReply(MessageModel message) {
    _replyingTo = message;
  }

  void cancelReply() {
    _replyingTo = null;
  }


  ChatController(this._repository);

  final ChatRepository _repository;

  List<MessageModel> get messages => _repository.messages;

  List<MessageModel> get filteredMessages {
    if (_searchQuery.trim().isEmpty) {
      return messages;
    }

    final q = _searchQuery.toLowerCase();

    return messages.where((m) {
      return m.text.toLowerCase().contains(q);
    }).toList();
  }


  Stream<List<MessageModel>> get messagesStream =>
      _repository.messagesStream;

  Future<void> start() async {
    _repository.loadMessages();
    await _repository.startListening();
  }

  Future<void> stop() async {
    await _repository.stopListening();
  }


  Future<void> sendTyping({
    required String from,
    required String to,
  }) async {
    await _repository.sendTyping(
      from: from,
      to: to,
    );
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

  Future<void> deleteMessage(String id) async {
    await _repository.deleteMessage(id);
  }

}
