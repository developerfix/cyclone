import 'dart:convert';
import 'package:http/http.dart' as http;

class MessagingRpository {
  sendNotification(Map<String, dynamic> notification, String token) async {
    print(
        'sendMessage start---------------------------------sendNotification---------------------------------');
    print('sendMessage  ' + token.toString());
    var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': notification,
          'to': token,
        },
      ),
    );
    print('res : ' + res.body);
    print(
        'sendMessage  end---------------------------------sendNotification---------------------------------\n\n');
  }

  String _serverToken =
      'AAAAOgXt1HE:APA91bEeNafqJyk9WbYHKBIkZrou7XuZTEdrPC-mQLLGOKg-vsd8buq47aO7YaSIGkXEI-nkvCXeXoG7WHljFGFO8rOFkrbfOtFDYNDDuS99NvloYB9k27cmaj95Ta7_ZcSW-D-_GDX5';
}
