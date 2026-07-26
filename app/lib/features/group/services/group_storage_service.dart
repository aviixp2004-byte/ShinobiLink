
import 'package:hive/hive.dart';

import '../../../models/group_model.dart';

class GroupStorageService {
  static const _boxName = 'groups';

  Box get _box => Hive.box(_boxName);

  Future<void> saveGroup(GroupModel group) async {
    await _box.put(
      group.id,
      group.toMap(),
    );
  }

  List<GroupModel> getGroups() {
    return _box.values
        .map(
          (e) => GroupModel.fromMap(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  Future<void> deleteGroup(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
