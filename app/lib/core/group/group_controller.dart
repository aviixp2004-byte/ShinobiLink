
import '../../models/group_model.dart';
import '../../repositories/group_repository.dart';

class GroupController {

  GroupController(this._repository);

  final GroupRepository _repository;

  List<GroupModel> get groups =>
      _repository.groups;

  Stream<List<GroupModel>> get groupsStream =>
      _repository.groupsStream;

  void start() {
    _repository.loadGroups();
  }

  Future<void> createGroup({
    required String name,
    required List<String> members,
  }) async {

    final group = GroupModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      name: name,
      members: members,
      createdAt: DateTime.now(),
    );

    await _repository.createGroup(group);
  }

  Future<void> deleteGroup(String id) async {
    await _repository.deleteGroup(id);
  }

  Future<void> dispose() async {
    await _repository.dispose();
  }
}
