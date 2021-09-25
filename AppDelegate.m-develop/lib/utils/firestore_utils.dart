import 'dart:developer';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String get conversationsPath => '/messages/${currentUser.id}/conversations/';

String specificConversationPath(userId) => '$conversationsPath$userId/';

String specificRecieverConversationPath(userId) =>
    '/messages/$userId/conversations/${currentUser.id}/';

String specificMessagesPath(userId) => '$conversationsPath$userId/messages/';

List<String> setSearchParams(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i];
    caseSearchList.add(temp.toLowerCase());
  }
  return caseSearchList;
}

//user path

String get currentUserPath => '/chatUsers/${currentUser.id}/';

List<ChatUser> loadedUsers = [];

Future<ChatUser> fetchUser(String userId, context) async {
  bool isUserStored = loadedUsers.where((e) => e.id == userId).length != 0;
  if (isUserStored) {
    // log('saved');
    return loadedUsers.where((e) => e.id == userId).first;
  } else {
    log('fetch user');

    var snap = await firestore.collection('chatUsers').doc(userId).get();
    ChatUser chatUser = ChatUser.fromMap(snap.data());

    print('user $userId : ' + chatUser.toString());

    if (chatUser != null && chatUser.name != null && chatUser.name.isNotEmpty) {
      loadedUsers.add(chatUser);
      firestore.doc(specificConversationPath(userId)).set(
          {nameCaseSearchField: setSearchParams(chatUser.name)},
          SetOptions(merge: true));
      return chatUser;
    } else {
      User user = await OpenbookProvider.of(context)
          .userService
          .getUserFromUserId(int.parse(userId));

      if (user == null) return null;
      ChatUser newChatUser = ChatUser.fromGeneralUser(user);
      loadedUsers.add(newChatUser);
      firestore.collection('chatUsers').doc(userId).set(
            newChatUser.toMap(),
            SetOptions(merge: true),
          );

      return newChatUser;
    }
  }
}

void storeUser(ChatUser user) {
  bool isUserStored =
      loadedUsers.where((element) => element.id == user.id).length != 0;
  if (!isUserStored) {
    if (user != null) {
      loadedUsers.add(user);
    }
  }
}

void setCurrentUser(User user) async {
  currentUser = ChatUser(
    id: user.id.toString(),
    name: user.profile.name,
    imageUrl: user.profile.avatar,
  );
  updateUser(currentUser);
}

void clearCurrentUser() async {
  firestore
      .doc(currentUserPath)
      .set({'token': '', 'chattingWith': ''}, SetOptions(merge: true));
}

void updateUser(ChatUser user) async {
  String token = await FirebaseMessaging.instance.getToken();
  firestore.doc(currentUserPath).set({
    'token': token,
    'chattingWith': '',
    'imageUrl': user.imageUrl,
    'name': user.name,
    'id': user.id,
  }, SetOptions(merge: true));
  log('user init and tokeeeeeeeeeeeeeeen : ' + token);
}

String getDistance(Map<String, dynamic> map) {
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
  if (point == null) return '';
  double kmDistance = point.distance(
      lat: currentUser.position.latitude, lng: currentUser.position.longitude);
  int mDistance = (kmDistance * 1000).toInt();
  return '$mDistance m';
}
