class MomentReaction {
  final int id;
  final String userId;
  final String name;
  final String reaction;
  final String avatar;
  final int story;

  MomentReaction({
    this.id,
    this.name,
    this.reaction,
    this.avatar,
    this.story,
    this.userId,
  });

  factory MomentReaction.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) return null;

    return MomentReaction(
      id: parsedJson['id'],
      name: parsedJson['name'],
      avatar: parsedJson['avatar'],
      reaction: parsedJson['reaction'],
      story: parsedJson['id'],
      userId: parsedJson['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': reaction,
      'emoji': reaction,
      'story': story,
      'name': name,
      'user_id': userId,
      'avatar': avatar,
    };
  }

  /*String getRelativeCreated() {
    return timeago.format(created);
  }*/

  String getReactorUsername() {
    return this.name;
  }

  String getReactorProfileAvatar() {
    return this.avatar;
  }

  int getReactorId() {
    return int.parse(this.userId);
  }
}
