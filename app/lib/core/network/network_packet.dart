import 'packet_type.dart';

class NetworkPacket {
  final PacketType type;
  final String id;
  final String senderId;
  final String payload;
  final DateTime timestamp;

  const NetworkPacket({
    required this.type,
    required this.id,
    required this.senderId,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'id': id,
      'senderId': senderId,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NetworkPacket.fromMap(Map<String, dynamic> map) {
    return NetworkPacket(
      type: PacketType.values.byName(map['type'] as String),
      id: map['id'] as String,
      senderId: map['senderId'] as String,
      payload: map['payload'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
