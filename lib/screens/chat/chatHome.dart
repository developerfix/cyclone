import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatpage.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  String userId;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final user = Provider.of<CycloneUser>(context);

    if (user != null) {
      final result = (await FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: user.uid)
              .get())
          .docs;

      if (result.length == 0) {
        ///new user
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          "id": user.uid,
          "name": user.name,
          "profile_pic": user.photoURL,
          "created_at": DateTime.now().millisecondsSinceEpoch,
        });

        sharedPreferences.setString("id", user.uid);
        sharedPreferences.setString("name", user.name);
        sharedPreferences.setString("profile_pic", user.photoURL);
      } else {
        ///Old user
        sharedPreferences.setString("id", result[0]["id"]);
        sharedPreferences.setString("name", result[0]["name"]);
        sharedPreferences.setString("profile_pic", result[0]["profile_pic"]);
      }

      userId = sharedPreferences.getString('id');
      print("userId");
      print(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chats'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (listContext, index) =>
                    buildItem(snapshot.data.docs[index]),
                itemCount: snapshot.data.docs.length,
              );
            }

            return Container();
          },
        ));
  }

  buildItem(doc) {
    return (userId != doc['id'])
        ? GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatPage(docs: doc)));
            },
            child: Card(
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Text(doc['name']),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
