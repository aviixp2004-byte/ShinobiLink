
import 'dart:async';

import '../models/group_model.dart';
import '../features/group/services/group_storage_service.dart';

class GroupRepository {
  final GroupStorageService _storage =
      GroupStorageService();

  final List<GroupModel> _groups = [];

  final StreamController<List<GroupModel>>
      _controller =
      StreamController<List<GroupModel>>.broadcast();

  List<GroupModel> get groups =>
      List.unmodifiable(_groups);

  Stream<List<GroupModel>> get groupsStream =>
      _controller.stream;

  void loadGroups() {
    _groups
      ..clear()
      ..addAll(_storage.getGroups());

    _notify();
  }

  Future<void> createGroup(GroupModel group) async {
    _groups.add(group);

    await _storage.saveGroup(group);

    _notify();
  }

  Future<void> deleteGroup(String id) async {
    _groups.removeWhere(
      (group) => group.id == id,
    );

    await _storage.deleteGroup(id);

    _notify();
  }

  void _notify() {
    _controller.add(
      List.unmodifiable(_groups),
    );
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
