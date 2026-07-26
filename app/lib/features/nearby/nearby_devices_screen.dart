import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import '../../core/connection/chat_connection.dart';
import '../../core/logging/app_logger.dart';
import '../../core/exceptions/app_exception.dart';

import '../../core/bluetooth/ble_service.dart';
import '../../core/connection/connection_service.dart';
import '../../core/connection/connection_state.dart' as connection_state;
import '../../core/wifi_direct/wifi_direct_repository.dart';
import '../../core/wifi_direct/wifi_direct_service.dart';
import '../../models/wifi_peer.dart';

class NearbyDevicesScreen extends StatefulWidget {
  const NearbyDevicesScreen({super.key});

  @override
  State<NearbyDevicesScreen> createState() =>
      _NearbyDevicesScreenState();
}

class _NearbyDevicesScreenState
    extends State<NearbyDevicesScreen> {
  final BleService _bleService = BleService();

  final WifiDirectRepository _wifiRepository =
      WifiDirectRepository(
        WifiDirectService(),
      );

  final ConnectionService _connectionService =
      ConnectionService.instance;

  List<WifiPeer> _wifiPeers = [];

  bool _connecting = false;

  @override
  void initState() {
    super.initState();

    _wifiRepository.initialize().then((ok) {
      if (ok) {
        _wifiRepository.discover();

        _wifiRepository.peers().listen((peers) {
          if (!mounted) return;

          setState(() {
            _wifiPeers = peers;
          });

          for (final peer in peers) {
            debugPrint(
              'Wi-Fi Direct: ${peer.name} (${peer.address})',
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Devices'),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: _bleService.scanResults(),
        builder: (context, snapshot) {
          final devices = snapshot.data ?? [];

          if (devices.isEmpty) {
            return const Center(
              child: Text('Scanning...'),
            );
          }

          return ListView(
            children: [
              if (_wifiPeers.isNotEmpty) ...[
                const ListTile(
                  title: Text(
                    'Wi-Fi Direct',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ..._wifiPeers.map(
                  (peer) => ListTile(
                    leading: const Icon(Icons.wifi),
                    title: Text(
                      peer.name.isEmpty ? 'Unknown Device' : peer.name,
                    ),
                    subtitle: Text(peer.address),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _connecting
                        ? null
                        : () async {
                            setState(() {
                              _connecting = true;
                            });

                            try {
                              final connection =
                                  await _wifiRepository.connect(
                                peer.address,
                              );

                              if (connection == null) {
                                throw WifiDirectException(
                                  'Wi-Fi Direct connection failed',
                                );
                              }

                              await _connectionService.connectWifi(
                                connection,
                              );

                              if (!context.mounted) return;

                              context.push(
                                '/chat',
                                extra: ChatConnection(
                                  deviceName: peer.name.isEmpty
                                      ? 'Wi-Fi Peer'
                                      : peer.name,
                                  connected:
                                      _connectionService.state ==
                                          connection_state.ConnectionState.connected,
                                ),
                              );
                            } on WifiDirectException catch (e) {
                              AppLogger.warning(e.message);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                ),
                              );
                            } catch (e, stackTrace) {
                              AppLogger.error(
                                'Unexpected Wi-Fi Direct error',
                                error: e,
                                stackTrace: stackTrace,
                              );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Connection failed'),
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _connecting = false;
                                });
                              }
                            }
                          },
                  ),
                ),
                const Divider(),
              ],

              const ListTile(
                title: Text(
                  'Bluetooth',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ...devices.map(
                (device) => ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(
                    device.device.platformName.isEmpty
                        ? 'Unknown Device'
                        : device.device.platformName,
                  ),
                  subtitle: Text(
                    device.device.remoteId.toString(),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    try {
                      await _bleService.connect(device.device);

                      if (!context.mounted) return;

                      context.push(
                        '/chat',
                        extra: ChatConnection(
                          deviceName: device.device.platformName.isEmpty
                              ? 'Unknown Device'
                              : device.device.platformName,
                          connected: true,
                        ),
                      );
                    } catch (e, stackTrace) {
                      AppLogger.error(
                        'Bluetooth connection failed',
                        error: e,
                        stackTrace: stackTrace,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Connection failed'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}