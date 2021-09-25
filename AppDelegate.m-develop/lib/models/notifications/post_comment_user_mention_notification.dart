import 'package:Siuu/models/post_comment_user_mention.dart';

class PostCommentUserMentionNotification {
  final int id;
  final PostCommentUserMention postCommentUserMention;

  PostCommentUserMentionNotification({this.id, this.postCommentUserMention});

  factory PostCommentUserMentionNotification.fromJson(
      Map<String, dynamic> json) {
    return PostCommentUserMentionNotification(
        id: json['id'],
        postCommentUserMention:
            _parsePostCommentUserMention(json['post_comment_user_mention']));
  }

  static PostCommentUserMention _parsePostCommentUserMention(
      Map postCommentUserMentionData) {
    return PostCommentUserMention.fromJSON(postCommentUserMentionData);
  }
}
