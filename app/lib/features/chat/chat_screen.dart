import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Timer? _typingRefreshTimer;

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

    _typingRefreshTimer =
        Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _typingRefreshTimer?.cancel();
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


  Future<void> _copyMessage(String message) async {
    await Clipboard.setData(ClipboardData(text: message));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied'),
        duration: Duration(seconds: 1),
      ),
    );
  }



  void _startReply(MessageModel message) {
    _chatController.startReply(message);

    if (!mounted) return;

    setState(() {});
  }



  String _findReplyText(MessageModel message) {
    if (message.replyTo == null) {
      return "";
    }

    for (final m in _chatController.messages) {
      if (m.id == message.replyTo) {
        return m.text;
      }
    }

    return "Original message unavailable";
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

                return GestureDetector(
                  onLongPress: () async {
                    final action = await showMenu<String>(
                      context: context,
                      position: const RelativeRect.fromLTRB(100, 300, 100, 300),
                      items: const [
                        PopupMenuItem(
                          value: 'reply',
                          child: Text('Reply'),
                        ),
                        PopupMenuItem(
                          value: 'copy',
                          child: Text('Copy'),
                        ),
                      ],
                    );

                    if (!mounted || action == null) return;

                    if (action == 'reply') {
                      _startReply(message);
                    } else if (action == 'copy') {
                      _copyMessage(message.text);
                    }
                  },
                  child: Align(
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
                        if (message.replyTo != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _findReplyText(message),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),

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
                ));

                  },
                );
              },
            ),
          ),
          if (_repository.peerTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Peer is typing...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          if (_chatController.replyingTo != null)
            Container(
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _chatController.replyingTo!.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _chatController.cancelReply();
                      setState(() {});
                    },
                  ),
                ],
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
