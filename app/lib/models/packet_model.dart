class PacketModel {
  final String id;
  final String from;
  final String to;
  final String type;
  final String payload;
  final int ttl;
  final DateTime timestamp;

  const PacketModel({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.payload,
    required this.ttl,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'type': type,
      'payload': payload,
      'ttl': ttl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PacketModel.fromJson(Map<String, dynamic> json) {
    return PacketModel(
      id: json['id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      type: json['type'] as String,
      payload: json['payload'] as String,
      ttl: json['ttl'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
