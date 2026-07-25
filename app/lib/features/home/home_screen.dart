import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/bluetooth/ble_controller.dart';
import '../../core/services/storage_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final BleController _bleController = BleController();

  @override
  Widget build(BuildContext context) {
    final name = StorageService.box.get('displayName', defaultValue: 'Guest');

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShinobiLink'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $name',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _bleController.startScanning();
                context.push('/nearby');
              },
              child: const Text('Scan Nearby Devices'),
            ),
          ],
        ),
      ),
    );
  }
}
