import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;

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
      status: MessageStatus.sending,
    );

    await _chatController.send(message);

    if (!mounted) return;

    setState(() {});
    _scrollToBottom();

    _textController.clear();
  }





  IconData _statusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.schedule;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }



  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
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
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatController.messagesStream,
              initialData: _chatController.messages,
              builder: (context, snapshot) {
                final messages = snapshot.data ?? const <MessageModel>[];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];

                final isMe = message.senderId == "me";

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(message.text),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(message.timestamp),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 6),
                              Icon(
                                _statusIcon(message.status),
                                size: 16,
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );
                  },
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
                      onChanged: (_) {
                        _typingTimer?.cancel();
                        _typingTimer = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            // TODO: send PacketType.typing
                          },
                        );
                      },
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
