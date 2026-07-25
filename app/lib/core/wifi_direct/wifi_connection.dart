class WifiConnection {
  final String deviceName;
  final String deviceAddress;
  final String ip;
  final int port;
  final bool isHost;

  const WifiConnection({
    required this.deviceName,
    required this.deviceAddress,
    required this.ip,
    required this.port,
    required this.isHost,
  });
}
