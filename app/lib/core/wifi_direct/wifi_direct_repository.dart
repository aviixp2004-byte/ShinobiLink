import '../../core/platform/wifi_direct_channel.dart';
import '../../models/wifi_peer.dart';
import 'wifi_connection.dart';
import 'wifi_direct_service.dart';

class WifiDirectRepository {
  WifiDirectRepository(this.service);

  final WifiDirectService service;

  final WifiDirectChannel _channel = WifiDirectChannel();

  Map<dynamic, dynamic>? _connectionInfo;

  Stream<List<WifiPeer>> peers() {
    return _channel.peers();
  }

  Future<bool> initialize() async {
    final result = await _channel.initialize();

    if (result) {
      _channel.connectionEvents().listen((event) {
        _connectionInfo = event;
      });
    }

    return result;
  }

  Future<bool> discover() {
    return _channel.discoverPeers();
  }

  Future<WifiConnection?> connect(String address) async {
    final connected = await _channel.connect(address);

    if (!connected) {
      return null;
    }

    final info = _connectionInfo;

    if (info == null) {
      return null;
    }

    return WifiConnection(
      deviceName: "Wi-Fi Peer",
      deviceAddress: address,
      ip: info['ip'] ?? "",
      port: 9000,
      isHost: info['isHost'] ?? false,
    );
  }

  Future<void> disconnect() {
    return _channel.disconnect();
  }
}
