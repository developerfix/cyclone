import 'dart:convert';

ReceivedMessage receivedMessageFromMap(String str) => ReceivedMessage.fromMap(json.decode(str));

String receivedMessageToMap(ReceivedMessage data) => json.encode(data.toMap());

class ReceivedMessage {
  ReceivedMessage({
    this.content,
    this.senderChatId,
    this.receiverChatId,
  });

  String content;
  String senderChatId;
  String receiverChatId;

  factory ReceivedMessage.fromMap(Map<String, dynamic> json) => ReceivedMessage(
    content: json["content"],
    senderChatId: json["senderChatID"],
    receiverChatId: json["receiverChatID"],
  );

  Map<String, dynamic> toMap() => {
    "content": content,
    "senderChatID": senderChatId,
    "receiverChatID": receiverChatId,
  };
}