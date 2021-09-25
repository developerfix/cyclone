
import 'dart:convert';


class SharedPost {
  SharedPost({
    this.postDetails,
    this.sharedUserDetails,
  });

  PostDetails postDetails;
  SharedUserDetails sharedUserDetails;

  factory SharedPost.fromMap(Map<String, dynamic> json) => SharedPost(
    postDetails: PostDetails.fromMap(json["post_details"]),
    sharedUserDetails: SharedUserDetails.fromMap(json["shared_user_details"]),
  );

  Map<String, dynamic> toMap() => {
    "post_details": postDetails.toMap(),
    "shared_user_details": sharedUserDetails.toMap(),
  };
}

class PostDetails {
  PostDetails({
    this.id,
    this.textAttached,
    this.postType,
    this.shareType,
    this.createdAt,
    this.modifiedAt,
    this.isDeleted,
    this.shareWith,
  });

  int id;
  String textAttached;
  String postType;
  String shareType;
  DateTime createdAt;
  DateTime modifiedAt;
  bool isDeleted;
  String shareWith;

  factory PostDetails.fromMap(Map<String, dynamic> json) => PostDetails(
    id: json["id"],
    textAttached: json["text_attached"] == null ? null : json["text_attached"],
    postType: json["post_type"],
    shareType: json["share_type"],
    createdAt: DateTime.parse(json["created_at"]),
    modifiedAt: DateTime.parse(json["modified_at"]),
    isDeleted: json["is_deleted"],
    shareWith: json["share_with"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "text_attached": textAttached == null ? null : textAttached,
    "post_type": postType,
    "share_type": shareType,
    "created_at": createdAt.toIso8601String(),
    "modified_at": modifiedAt.toIso8601String(),
    "is_deleted": isDeleted,
    "share_with": shareWith,
  };
}

class SharedUserDetails {
  SharedUserDetails({
    this.name,
    this.userId,
    this.avatar,
    this.cover,
  });

  String name;
  int userId;
  dynamic avatar;
  dynamic cover;

  factory SharedUserDetails.fromMap(Map<String, dynamic> json) => SharedUserDetails(
    name: json["name"],
    userId: json["user_id"],
    avatar: json["avatar"],
    cover: json["cover"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "user_id": userId,
    "avatar": avatar,
    "cover": cover,
  };
}
