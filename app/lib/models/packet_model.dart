import '../core/network/packet_type.dart';

class PacketModel {
  final String id;
  final String from;
  final String to;
  final PacketType type;
  final String payload;
  final int ttl;
  final DateTime timestamp;
  final String? replyTo;
  final String? groupId;

  const PacketModel({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.payload,
    required this.ttl,
    required this.timestamp,
    this.replyTo,
    this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'type': type.name,
      'payload': payload,
      'ttl': ttl,
      'timestamp': timestamp.toIso8601String(),
      'replyTo': replyTo,
      'groupId': groupId,
    };
  }

  

  bool get isAck => type == PacketType.ack;

  bool get isMessage => type == PacketType.message;

  bool get isImage => type == PacketType.image;

  bool get isFile => type == PacketType.file;

  factory PacketModel.fromJson(Map<String, dynamic> json) {
    return PacketModel(
      id: json['id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      type: PacketType.values.byName(json['type'] as String),
      payload: json['payload'] as String,
      ttl: json['ttl'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      replyTo: json['replyTo'] as String?,
      groupId: json['groupId'] as String?,
    );
  }
}
