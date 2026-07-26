
import 'package:flutter/material.dart';

import '../../core/group/group_message_controller.dart';
import '../../models/group_model.dart';
import '../../models/message_model.dart';

class GroupChatScreen extends StatefulWidget {

  final GroupModel group;
  final GroupMessageController controller;

  const GroupChatScreen({
    super.key,
    required this.group,
    required this.controller,
  });

  @override
  State<GroupChatScreen> createState() =>
      _GroupChatScreenState();
}


class _GroupChatScreenState
    extends State<GroupChatScreen> {

  final TextEditingController _textController =
      TextEditingController();


  Future<void> _send() async {

    final text =
        _textController.text.trim();

    if (text.isEmpty) return;


    final message = MessageModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      senderId: "me",
      receiverId: widget.group.id,
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );


    await widget.controller.sendToGroup(
      group: widget.group,
      message: message,
    );


    _textController.clear();
  }


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),

      body: Column(
        children: [

          const Expanded(
            child: Center(
              child: Text(
                'Group messages',
              ),
            ),
          ),


          Row(
            children: [

              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Message group',
                  ),
                ),
              ),


              IconButton(
                onPressed: _send,
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
