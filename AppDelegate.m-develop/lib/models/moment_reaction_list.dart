import 'package:Siuu/models/moment_reaction.dart';

class MomentReactionList {
  final List<MomentReaction> reactions;
  final int reactionsCount;

  MomentReactionList({
    this.reactionsCount,
    this.reactions,
  });

  factory MomentReactionList.fromJson(Map<String, dynamic> parsedJson) {
    List<MomentReaction> momentReactions = (parsedJson['data'] as List)
        .map((momentJson) => MomentReaction.fromJson(momentJson))
        .toList();

    return new MomentReactionList(
      reactionsCount: parsedJson['Reactin_Count'],
      reactions: momentReactions,
    );
  }
}
