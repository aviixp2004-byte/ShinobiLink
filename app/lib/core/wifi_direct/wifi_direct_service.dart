import 'wifi_direct_state.dart';

class WifiDirectService {
  WifiDirectState _state = WifiDirectState.disabled;

  WifiDirectState get state => _state;

  Future<void> startDiscovery() async {
    _state = WifiDirectState.discovering;
  }

  Future<void> connect(String deviceId) async {
    _state = WifiDirectState.connecting;

    await Future.delayed(const Duration(seconds: 1));

    _state = WifiDirectState.connected;
  }

  Future<void> disconnect() async {
    _state = WifiDirectState.disabled;
  }
}
