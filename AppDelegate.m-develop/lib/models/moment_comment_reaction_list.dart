/*
import 'package:Siuu/models/moment_comment_reaction.dart';

class MomentCommentReactionList {
  final List<MomentCommentReaction> reactions;

  MomentCommentReactionList({
    this.reactions,
  });

  factory MomentCommentReactionList.fromJson(List<dynamic> parsedJson) {
    List<MomentCommentReaction> postCommentReactions = parsedJson
        .map((postCommentJson) =>
            MomentCommentReaction.fromJson(postCommentJson))
        .toList();

    return new MomentCommentReactionList(
      reactions: postCommentReactions,
    );
  }
}
*/