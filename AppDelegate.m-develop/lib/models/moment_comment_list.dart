import 'package:Siuu/models/moment_comment.dart';

class MomentCommentList {
  int commentCount;
  List<MomentComment> comments;

  MomentCommentList({
    this.commentCount,
    this.comments,
  });

  factory MomentCommentList.fromJson(Map<String, dynamic> json) =>
      MomentCommentList(
        commentCount: json["Comment_Count"],
        comments: List<MomentComment>.from(
            json["data"].map((x) => MomentComment.fromJson(x))),
      );
}
