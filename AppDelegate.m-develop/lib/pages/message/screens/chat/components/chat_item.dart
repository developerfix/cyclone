import 'dart:async';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/cubit/typing_cubit.dart';
import 'package:Siuu/models/latest_message_model.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/home/pages/profile/profile_loader.dart';
import 'package:Siuu/pages/message/components/UserAvatar.dart';
import 'package:Siuu/pages/message/components/custom_dialog.dart';
import 'package:Siuu/repository/conversation_repository.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class ChatItem extends StatelessWidget {
  final String userId;
  final int newMessagesNum;
  final bool isMuted;
  final Timestamp messageTime;
  final LatestMessage latestMessage;
  final SwipeActionController controller = SwipeActionController();

  ChatItem({
    @required this.userId,
    @required this.newMessagesNum,
    @required this.messageTime,
    @required this.latestMessage,
    @required this.isMuted,
  });

  bool deletePresed = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatUser>(
        future: fetchUser(userId, context),
        builder: (_, snapshot) {
          ChatUser _user = snapshot.data;
          // if (_user == null) return Container();

          return SwipeActionCell(
            child: GestureDetector(
              onTap: () => goToConverstation(context, _user),
              child: Container(
                color: Colors.white,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileLoader(userId: int.parse(userId)),
                                ),
                              );
                            },
                            child: UserAvatar(user: _user),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProfileLoader(
                                            userId: int.parse(userId)),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    _user == null ? '...' : _user.name,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: BlocBuilder<TypingCubit, TypingState>(
                                    builder: (_, state) {
                                      bool isWriting = state is TypingTrue;
                                      return Text(
                                        isWriting
                                            ? 'Typing...'
                                            : "${latestMessage.isMe ? 'You : ' : ''} ${latestMessage.text}",
                                        style: TextStyle(
                                          color: isWriting
                                              ? Color(pinkColor)
                                              : Colors.blueGrey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            messageTime == null
                                ? '...'
                                : fullDate(
                                    context,
                                    date: messageTime.toDate(),
                                    withTime: true,
                                  ),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              newMessagesNum != 0
                                  ? Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: linearGradient,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            newMessagesNum > 999
                                                ? 'XD'
                                                : newMessagesNum.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6.0),
                                      ],
                                    )
                                  : Container(),
                              GestureDetector(
                                onTap: () {
                                  firestore
                                      .doc(specificConversationPath(userId))
                                      .set({isMutedField: !isMuted},
                                          SetOptions(merge: true));
                                },
                                child: Icon(
                                  isMuted
                                      ? Icons.volume_off_rounded
                                      : Icons.volume_up_rounded,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color:
                        newMessagesNum != 0 ? Color(accentColor) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            key: ObjectKey(userId),
            controller: controller,
            trailingActions: <SwipeAction>[
              SwipeAction(
                  icon: CupertinoButton(
                    onPressed: () async {
                      await confirmDelete(context);
                      controller.closeAllOpenCell();
                    },
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  onTap: (_) {},
                  color: Colors.red),
            ],
          );
        });
  }

  Future<void> confirmDelete(BuildContext context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (cnt) {
          return CustomDialogBox(
            title: "Warning",
            descriptions: "Are you sure you want to delete this Conversation?",
            text: "Delete",
            onPressed: () async =>
                await ConversationRepository.deleteConversation(userId),
          );
        });
  }
}
