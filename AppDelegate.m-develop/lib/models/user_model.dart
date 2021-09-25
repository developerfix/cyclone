import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:Siuu/models/user.dart';

class ChatUser {
  final String id;
  final String name;
  final String imageUrl;
  String token;
  GeoFirePoint position;

  ChatUser({
    @required this.id,
    @required this.name,
    this.imageUrl,
    this.token,
    this.position,
  });

  factory ChatUser.fromGeneralUser(User _user) {
    return ChatUser(
      id: _user.id.toString(),
      name: _user.profile.name,
      imageUrl: _user.profile.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'token': token,
      'position': position == null ? null : position.data
    };
    if (position != null) return map;
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    GeoFirePoint point;
    try {
      if (map.containsKey('position')) {
        double latitude = map['position']['geopoint'].latitude;
        double longitude = map['position']['geopoint'].longitude;
        if (latitude != null && longitude != null) {
          point = GeoFirePoint(latitude, longitude);
        } else {
          point = null;
        }
      } else {
        point = null;
      }
    } catch (e) {
      point = null;
    }
    return ChatUser(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      token: map['token'],
      position: point,
    );
  }

  void setPosition(GeoFirePoint point) => position = point;

  @override
  String toString() {
    return 'ChatUser(id: $id, name: $name, imageUrl: $imageUrl, token: $token, position: $position)';
  }
}
