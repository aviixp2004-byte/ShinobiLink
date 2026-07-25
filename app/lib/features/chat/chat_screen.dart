import 'package:flutter/material.dart';

import '../../core/chat/chat_controller.dart';
import '../../core/connection/chat_connection.dart';
import '../../core/chat/chat_engine.dart';
import '../../core/network/network_manager.dart';
import '../../models/message_model.dart';
import '../../repositories/chat_repository.dart';

class ChatScreen extends StatefulWidget {
  final ChatConnection connection;

  const ChatScreen({
    super.key,
    required this.connection,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  final ChatRepository _repository = ChatRepository(
    networkManager: NetworkManager(),
    chatEngine: ChatEngine(),
  );

  late final ChatController _chatController =
      ChatController(_repository);

  @override
  void initState() {
    super.initState();

    _chatController.start();
  }

  @override
  void dispose() {
    _textController.dispose();
    _chatController.stop();
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();

    if (text.isEmpty) return;

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: "me",
      receiverId: "peer",
      text: text,
      timestamp: DateTime.now(),
      delivered: false,
    );

    await _chatController.send(message);

    if (!mounted) return;

    setState(() {});

    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.connection.deviceName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatController.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_chatController.messages[index].text),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
