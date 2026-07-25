import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

/// Chat screen
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.chat),
      ),
      body: const Center(
        child: Text('Chat Screen - Coming Soon'),
      ),
    );
  }
}
