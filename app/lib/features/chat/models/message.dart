class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isMine;
  final String status;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.isMine,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'isMine': isMine,
        'status': status,
      };

  factory Message.fromMap(Map map) => Message(
        id: map['id'],
        senderId: map['senderId'],
        receiverId: map['receiverId'],
        text: map['text'],
        timestamp: DateTime.parse(map['timestamp']),
        isMine: map['isMine'],
        status: map['status'],
      );
}
