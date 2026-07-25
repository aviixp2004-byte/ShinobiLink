import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../repositories/chat_repository.dart';
import '../../core/chat/chat_engine.dart';
import '../../core/network/network_manager.dart';

class ChatScreen extends StatefulWidget {
  final String deviceName;

  const ChatScreen({
    super.key,
    required this.deviceName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final ChatRepository _repository = ChatRepository(
  networkManager: NetworkManager(),
  chatEngine: ChatEngine(),
);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
      final text = _controller.text.trim();

      if (text.isEmpty) return;

      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: "me",
        receiverId: "peer",
        text: text,
        timestamp: DateTime.now(),
        delivered: false,
      );

      await _repository.send(message);

      if (!mounted) return;

      setState(() {});

      _controller.clear();
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deviceName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _repository.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_repository.messages[index].text),
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
                      controller: _controller,
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