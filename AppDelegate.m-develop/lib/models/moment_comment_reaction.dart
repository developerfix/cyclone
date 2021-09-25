/*
import 'package:Siuu/models/emoji.dart';
import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class MomentCommentReaction {
  final int id;
  final DateTime created;
  final Emoji emoji;
  final User reactor;
  final MomentComment momentComment;

  MomentCommentReaction(
      {this.id, this.created, this.emoji, this.reactor, this.momentComment});

  factory MomentCommentReaction.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) return null;
    DateTime created;
    var createdData = parsedJson['created'];
    if (createdData != null) created = DateTime.parse(createdData).toLocal();

    User reactor;
    var reactorData = parsedJson['reactor'];
    if (reactorData != null) reactor = User.fromJson(reactorData);

    MomentComment momentComment;
    if (parsedJson.containsKey('post_comment')) {
      momentComment = MomentComment.fromJSON(parsedJson['post_comment']);
    }

    Emoji emoji = Emoji.fromJson(parsedJson['emoji']);

    return MomentCommentReaction(
        id: parsedJson['id'],
        created: created,
        reactor: reactor,
        emoji: emoji,
        momentComment: momentComment);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created?.toString(),
      'emoji': emoji.toJson(),
      'reactor': reactor.toJson(),
      'post_comment': momentComment.toJson()
    };
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  String getReactorUsername() {
    return this.reactor.username;
  }

  String getReactorProfileAvatar() {
    return this.reactor.getProfileAvatar();
  }

  int getReactorId() {
    return this.reactor.id;
  }

  int getEmojiId() {
    return this.emoji.id;
  }

  String getEmojiImage() {
    return this.emoji.image;
  }

  String getEmojiKeyword() {
    return this.emoji.keyword;
  }

  MomentCommentReaction copy({Emoji newEmoji}) {
    return MomentCommentReaction(emoji: newEmoji ?? emoji);
  }
}
*/