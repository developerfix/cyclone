import 'dart:convert';

import 'package:flutter_socket_io/flutter_socket_io.dart';

import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:Siuu/siuuchat/chatCallback.dart';

class Socketint {
  SocketIO socketIO;
  ChatCallBack mychatCallBack;
  Socketint({this.mychatCallBack});

  SocketIO getInstance(String profileId) {
    if (socketIO == null) {
      socketIO = SocketIOManager().createSocketIO(
          'http://192.168.100.49:3000', '/',
          query: 'chatID=${profileId}');
      socketIO.init();
      socketIO.subscribe('receive_message', (jsonData) {
        print("tetopati:" + jsonData.toString());
        if (mychatCallBack != null) {
          mychatCallBack.onMessageReceived(jsonData);
        }
      });
      socketIO.connect();
    } else {}

    return socketIO;
  }

  void sendMessage({String text, String receiverChatID, String senderChatId}) {
    // messages.add(Message(text, currentUser.chatID, receiverChatID));
    getInstance(senderChatId).sendMessage(
      'send_message',
      json.encode({
        'receiverChatID': receiverChatID,
        'senderChatID': senderChatId,
        'content': text,
      }),
    );
    //notifyListeners();
  }
}
