// To parse this JSON data, do
//
//     final userStory = userStoryFromJson(jsonString);

import 'dart:convert';

import 'package:Siuu/models/user.dart';

UserStory userStoryFromJson(String str) => UserStory.fromJson(json.decode(str));

String userStoryToJson(UserStory data) => json.encode(data.toJson());

class UserStory {
  UserStory({
    this.myStories,
    this.stories,
    this.onMapStories,
  });

  List<Story> myStories;
  List<Story> stories;
  List<Story> onMapStories;

  factory UserStory.fromJson(Map<String, dynamic> json) => UserStory(
        myStories:
            List<Story>.from(json["my_stories"].map((x) => Story.fromJson(x))),
        stories:
            List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
        onMapStories: List<Story>.from(
            json["on_map_stories"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "my_stories": List<dynamic>.from(myStories.map((x) => x.toJson())),
        "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
        "on_map_stories":
            List<dynamic>.from(onMapStories.map((x) => x.toJson())),
      };
}

class Story {
  Story({
    this.id,
    this.text,
    this.font,
    this.time,
    this.userId,
    this.name,
    this.username,
    this.type,
    this.image,
    this.width,
    this.height,
    this.video,
    this.isSharedOnMap,
    this.lat,
    this.long,
    this.background,
    this.avatar,
    this.user,
    this.is_viewed,
    this.views_count,
    this.likes_count,
    this.dislikes_count,
    this.comment_count,
  });

  int id;
  String text;
  String font;
  DateTime time;
  String userId;
  dynamic name;
  String username;
  String type;
  String image;
  int width;
  int height;
  String video;
  String isSharedOnMap;
  dynamic lat;
  dynamic long;
  dynamic background;
  dynamic avatar;
  User user;
  bool is_viewed;
  int views_count, likes_count, dislikes_count, comment_count;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        text: json["text"] == null ? null : json["text"],
        font: json["font_style"] == null ? null : json["font_style"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        userId: json["user_id"],
        name: json["name"],
        username: json["username"],
        type: json["type"],
        image: json["image"] == null ? null : json["image"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        video: json["video"] == null ? null : json["video"],
        isSharedOnMap: json["is_shared_on_map"],
        lat: json["lat"],
        long: json["long"],
        background: json["background"],
        avatar: json["avatar"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        is_viewed: json['is_viewed'] == null ? null : json['is_viewed'],
        views_count: json['views_count'] == null ? null : json['views_count'],
        likes_count: json['likes_count'] == null ? null : json['likes_count'],
        dislikes_count:
            json['dislikes_count'] == null ? null : json['dislikes_count'],
        comment_count:
            json['comment_count'] == null ? null : json['comment_count'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text == null ? null : text,
        "font_style": font == null ? null : font,
        "time": time.toIso8601String(),
        "user_id": userId,
        "name": name,
        "username": username,
        "type": type,
        "image": image == null ? null : image,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "video": video == null ? null : video,
        "is_shared_on_map": isSharedOnMap,
        "lat": lat,
        "long": long,
        "background": background,
        "avatar": avatar,
        "user": user.toJson(),
        "is_viewed": is_viewed,
        'views_count': views_count,
        'likes_count': likes_count,
        'dislikes_count': dislikes_count,
        'comment_count': comment_count,
      };
}
