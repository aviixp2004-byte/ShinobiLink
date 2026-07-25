import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';

import '../../core/bluetooth/ble_service.dart';

class NearbyDevicesScreen extends StatelessWidget {
  NearbyDevicesScreen({super.key});

  final BleService _bleService = BleService();

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

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];

              return ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(
                  device.device.platformName.isEmpty
                      ? 'Unknown Device'
                      : device.device.platformName,
                ),
                subtitle: Text(device.device.remoteId.toString()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  try {
                    await _bleService.connect(device.device);

                    if (!context.mounted) return;

                    context.push(
                      '/chat',
                      extra: device.device.platformName.isEmpty
                          ? 'Unknown Device'
                          : device.device.platformName,
                    );
                  } catch (_) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Connection failed'),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
