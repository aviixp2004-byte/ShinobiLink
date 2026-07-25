import 'dart:convert';

class HandshakeModel {
  final String deviceId;
  final String deviceName;
  final String ip;
  final int port;
  final String role;

  const HandshakeModel({
    required this.deviceId,
    required this.deviceName,
    required this.ip,
    required this.port,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'deviceName': deviceName,
        'ip': ip,
        'port': port,
        'role': role,
      };

  factory HandshakeModel.fromJson(Map<String, dynamic> json) {
    return HandshakeModel(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      ip: json['ip'] as String,
      port: json['port'] as int,
      role: json['role'] as String,
    );
  }

  String encode() => jsonEncode(toJson());

  factory HandshakeModel.decode(String source) {
    return HandshakeModel.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}
