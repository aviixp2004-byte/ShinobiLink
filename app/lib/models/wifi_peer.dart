class WifiPeer {
  final String name;
  final String address;

  const WifiPeer({
    required this.name,
    required this.address,
  });

  factory WifiPeer.fromMap(Map<dynamic, dynamic> map) {
    return WifiPeer(
      name: map['name'] as String,
      address: map['address'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
      };
}
