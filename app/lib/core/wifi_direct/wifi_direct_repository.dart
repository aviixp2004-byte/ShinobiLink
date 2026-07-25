import '../../core/platform/wifi_direct_channel.dart';
import '../../models/wifi_peer.dart';
import 'wifi_direct_service.dart';

class WifiDirectRepository {
  WifiDirectRepository(this.service);

  final WifiDirectService service;
  final WifiDirectChannel _channel = WifiDirectChannel();

  Stream<List<WifiPeer>> peers() {
    return _channel.peers();
  }

  Future<bool> initialize() {
    return _channel.initialize();
  }

  Future<bool> discover() {
    return _channel.discoverPeers();
  }

  Future<bool> connect(String address) {
    return _channel.connect(address);
  }

  Future<void> disconnect() {
    return _channel.disconnect();
  }
}
