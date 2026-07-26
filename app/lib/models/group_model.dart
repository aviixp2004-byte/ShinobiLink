
class GroupModel {
  final String id;
  final String name;
  final List<String> members;
  final DateTime createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] as String,
      name: map['name'] as String,
      members: List<String>.from(map['members'] as List),
      createdAt: DateTime.parse(
        map['createdAt'] as String,
      ),
    );
  }
}
