import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/cubit/typing_cubit.dart';
import 'package:Siuu/models/latest_message_model.dart';
import 'package:Siuu/pages/message/components/custom_progress.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_item.dart';

class RecentChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection(conversationsPath)
                .orderBy(newMessageTimestampField, descending: true)
                .snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> usersSnap) {
              if (!usersSnap.hasData) return CustomCircularIndicator();
              if (usersSnap.data == null) return Center(child: Text('error'));
              if (usersSnap.data.docs.isEmpty)
                return Center(
                    child: Text(
                  'There is no Conversations.',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ));
              return ListView.builder(
                itemCount: usersSnap.data.docs.length,
                itemBuilder: (_, int index) {
                  String userId = usersSnap.data.docs[index].id;
                  LatestMessage latestMessage = LatestMessage.fromMap(
                      usersSnap.data.docs[index].get(latestMessageField));
                  int newMessagesNum =
                      usersSnap.data.docs[index].get(newMessagesNumField);
                  Timestamp messageTime =
                      usersSnap.data.docs[index].get(newMessageTimestampField);
                  bool isMuted = false;
                  try {
                    isMuted = usersSnap.data.docs[index].get(isMutedField);
                  } catch (e) {}

                  return BlocProvider(
                    create: (_) => TypingCubit(userId),
                    child: ChatItem(
                      userId: userId,
                      newMessagesNum: newMessagesNum,
                      messageTime: messageTime,
                      latestMessage: latestMessage,
                      isMuted: isMuted,
                    ),
                  );
                },
              );
            }),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }
}
