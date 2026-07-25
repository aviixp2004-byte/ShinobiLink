import 'wifi_direct_service.dart';

class WifiDirectRepository {
  final WifiDirectService service;

  WifiDirectRepository(this.service);

  Future<void> discover() => service.startDiscovery();

  Future<void> connect(String id) => service.connect(id);

  Future<void> disconnect() => service.disconnect();
}
