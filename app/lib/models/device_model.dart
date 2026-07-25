class DeviceModel {
  final String id;
  final String name;
  final bool isConnected;
  final int rssi;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.isConnected,
    required this.rssi,
  });

  DeviceModel copyWith({
    String? id,
    String? name,
    bool? isConnected,
    int? rssi,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isConnected: isConnected ?? this.isConnected,
      rssi: rssi ?? this.rssi,
    );
  }
}
