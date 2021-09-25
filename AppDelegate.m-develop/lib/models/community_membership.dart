class MemoryMembership {
  final int id;
  final int userId;
  final int crewId;
  bool isAdministrator;
  bool isModerator;

  MemoryMembership(
      {this.id,
      this.userId,
      this.crewId,
      this.isAdministrator,
      this.isModerator});

  factory MemoryMembership.fromJSON(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) return null;
    return MemoryMembership(
        id: parsedJson['id'],
        crewId: parsedJson['community_id'],
        userId: parsedJson['user_id'],
        isAdministrator: parsedJson['is_administrator'],
        isModerator: parsedJson['is_moderator']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'community_id': crewId,
      'is_administrator': isAdministrator,
      'is_moderator': isModerator
    };
  }

  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('is_administrator'))
      isAdministrator = json['is_administrator'];
    if (json.containsKey('is_moderator')) isModerator = json['is_moderator'];
  }
}
