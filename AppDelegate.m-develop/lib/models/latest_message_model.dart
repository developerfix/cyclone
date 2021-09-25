import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:flutter/cupertino.dart';

class LatestMessage {
  final String senderId;
  final String text;
  final int type;

  LatestMessage({
    @required this.senderId,
    @required this.text,
    @required this.type,
  });
  bool get isMe => senderId == currentUser.id;

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type,
    };
  }

  factory LatestMessage.fromMap(Map<String, dynamic> map) {
    return LatestMessage(
      senderId: map['senderId'],
      text: map['text'],
      type: map['type'],
    );
  }

  factory LatestMessage.fromMessage(Message msg) {
    return LatestMessage(
      senderId: msg.senderId,
      text: msg.text,
      type: msg.type,
    );
  }
}
