import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/components/UserAvatar.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadedIcon extends StatefulWidget {
  final ChatUser user;
  final String msgId;
  const ReadedIcon({@required this.user, @required this.msgId});

  @override
  _ReadedIconState createState() => _ReadedIconState();
}

class _ReadedIconState extends State<ReadedIcon> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            firestore.doc(specificConversationPath(widget.user.id.toString())).snapshots(),
        builder: (context, snapshot) {
          String lstMsgReaded = '';
          if (snapshot.hasData) {
            try {
              lstMsgReaded = snapshot.hasError
                  ? ''
                  : snapshot.data.get(latestMessageReadedField);
            } catch (e) {}
          }
          return AnimatedSize(
            duration: const Duration(milliseconds: 200),
            vsync: this,
            child: lstMsgReaded == widget.msgId
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserAvatar(
                          user: widget.user,
                          size: 20,
                        )),
                  )
                : Container(),
          );
        });
  }
}
