import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = TextEditingController();

  Future<void> _continue() async {
    final name = _controller.text.trim();

    if (name.isEmpty) return;

    await StorageService.box.put('displayName', name);

    if (!mounted) return;

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Display Name',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _continue,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
