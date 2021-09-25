import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/user.dart';
/*
class MomentCommentUserMention {
  final int id;
  final User user;
  final MomentComment momentComment;

  MomentCommentUserMention({
    this.id,
    this.user,
    this.momentComment,
  });

  factory MomentCommentUserMention.fromJSON(Map<String, dynamic> parsedJson) {
    return MomentCommentUserMention(
      id: parsedJson['id'],
      user: parseUser(parsedJson['user']),
      momentComment: parseMomentComment(parsedJson['moment_comment']),
    );
  }

  static User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  static MomentComment parseMomentComment(Map momentCommentData) {
    if (momentCommentData == null) return null;
    return MomentComment.fromJson(momentCommentData);
  }
}
*/