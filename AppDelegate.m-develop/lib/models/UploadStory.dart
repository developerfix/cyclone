// To parse this JSON data, do
//
//     final uploadStory = uploadStoryFromJson(jsonString);

import 'dart:convert';

UploadStory uploadStoryFromJson(String str) => UploadStory.fromJson(json.decode(str));

String uploadStoryToJson(UploadStory data) => json.encode(data.toJson());

class UploadStory {
  UploadStory({
    this.message,
    this.status,
    this.data,
  });

  String message;
  int status;
  Data data;

  factory UploadStory.fromJson(Map<String, dynamic> json) => UploadStory(
    message: json["message"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.text,
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
  });

  int id;
  dynamic text;
  DateTime time;
  String userId;
  dynamic name;
  dynamic username;
  String type;
  String image;
  int width;
  int height;
  dynamic video;
  String isSharedOnMap;
  String lat;
  String long;
  dynamic background;
  dynamic avatar;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    text: json["text"],
    time: DateTime.parse(json["time"]),
    userId: json["user_id"],
    name: json["name"],
    username: json["username"],
    type: json["type"],
    image: json["image"],
    width: json["width"],
    height: json["height"],
    video: json["video"],
    isSharedOnMap: json["is_shared_on_map"],
    lat: json["lat"],
    long: json["long"],
    background: json["background"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "time": time.toIso8601String(),
    "user_id": userId,
    "name": name,
    "username": username,
    "type": type,
    "image": image,
    "width": width,
    "height": height,
    "video": video,
    "is_shared_on_map": isSharedOnMap,
    "lat": lat,
    "long": long,
    "background": background,
    "avatar": avatar,
  };
}
