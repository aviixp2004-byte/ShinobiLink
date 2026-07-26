enum MessageStatus {
  sending,
  sent,
  delivered,
  failed,
}

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final String? replyTo;
  final MessageStatus status;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.replyTo,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      text: map['text'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      status: MessageStatus.values.byName(map['status'] as String),
    );
  }
}
