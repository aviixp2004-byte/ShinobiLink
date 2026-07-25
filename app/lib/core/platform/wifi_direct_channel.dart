import 'package:flutter/services.dart';

import '../../models/wifi_peer.dart';

class WifiDirectChannel {
  static const MethodChannel _methodChannel =
      MethodChannel('shinobilink/wifi_direct');

  static const EventChannel _eventChannel =
      EventChannel('shinobilink/wifi_direct/events');

  Future<bool> initialize() async {
    return await _methodChannel.invokeMethod<bool>('initialize') ?? false;
  }

  Future<bool> discoverPeers() async {
    return await _methodChannel.invokeMethod<bool>('discoverPeers') ?? false;
  }

  Future<bool> connect(String deviceAddress) async {
    return await _methodChannel.invokeMethod<bool>(
          'connect',
          {
            'deviceAddress': deviceAddress,
          },
        ) ??
        false;
  }

  Future<void> disconnect() async {
    await _methodChannel.invokeMethod('disconnect');
  }

  Stream<List<WifiPeer>> peers() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final list = (event as List)
          .cast<Map<dynamic, dynamic>>()
          .map(WifiPeer.fromMap)
          .toList();

      return list;
    });
  }
}
