import 'dart:convert';
import 'package:Siuu/models/user.dart';
import 'package:flutter/foundation.dart';

class MomentComment {
  MomentComment({
    @required this.id,
    @required this.userId,
    @required this.name,
    @required this.avatar,
    @required this.text,
    @required this.emoji,
    @required this.time,
    @required this.story,
    @required this.commenter,
  });

  final int id;
  final String userId;
  final String name;
  final String avatar;
  final String text;
  final dynamic emoji;
  final DateTime time;
  final int story;
  final User commenter;

  factory MomentComment.fromRawJson(String str) =>
      MomentComment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MomentComment.fromJson(Map<String, dynamic> json) => MomentComment(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        avatar: json["avatar"],
        text: json["text"],
        emoji: json["emoji"],
        time: DateTime.parse(json["time"]),
        story: json["story"],
        commenter: User.fromJson(json["commenter"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "avatar": avatar,
        "text": text,
        "emoji": emoji,
        "time": time.toIso8601String(),
        "story": story,
        "commenter": commenter.toJson(),
      };
}
