import 'package:hive/hive.dart';

import '../../../models/message_model.dart';

class ChatStorageService {
  static const _boxName = 'messages';

  Box get _box => Hive.box(_boxName);

  Future<void> saveMessage(MessageModel message) async {
    await _box.put(message.id, message.toMap());
  }

  List<MessageModel> getMessages() {
    return _box.values
        .map((e) => MessageModel.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> deleteMessage(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
