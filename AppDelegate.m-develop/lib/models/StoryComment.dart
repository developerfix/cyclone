// To parse this JSON data, do
//
//     final storyComment = storyCommentFromMap(jsonString);

import 'dart:convert';

StoryComment storyCommentFromMap(String str) =>
    StoryComment.fromMap(json.decode(str));

String storyCommentToMap(StoryComment data) => json.encode(data.toMap());

class StoryComment {
  StoryComment({
    this.commentCount,
    this.data,
  });

  int commentCount;
  List<Comments> data;

  factory StoryComment.fromMap(Map<String, dynamic> json) => StoryComment(
        commentCount: json["Comment_Count"],
        data: List<Comments>.from(json["data"].map((x) => Comments.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Comment_Count": commentCount,
        "data": List<Comments>.from(data.map((x) => x.toMap())),
      };
}

class Comments {
  Comments({
    this.id,
    this.userId,
    this.name,
    this.avatar,
    this.text,
    this.emoji,
    this.time,
    this.story,
  });

  int id;
  String userId;
  dynamic name;
  dynamic avatar;
  String text;
  dynamic emoji;
  DateTime time;
  int story;

  factory Comments.fromMap(Map<String, dynamic> json) => Comments(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        avatar: json["avatar"],
        text: json["text"],
        emoji: json["emoji"],
        time: DateTime.parse(json["time"]),
        story: json["story"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "avatar": avatar,
        "text": text,
        "emoji": emoji,
        "time": time.toIso8601String(),
        "story": story,
      };
}
