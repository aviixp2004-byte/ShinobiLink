
import '../../models/group_model.dart';
import '../../models/message_model.dart';
import '../../repositories/chat_repository.dart';

class GroupMessageController {

  GroupMessageController(this._chatRepository);

  final ChatRepository _chatRepository;


  Future<void> sendToGroup({
    required GroupModel group,
    required MessageModel message,
  }) async {

    await _chatRepository.sendGroupMessage(
      message: message,
      members: group.members,
      groupId: group.id,
    );
  }

}
