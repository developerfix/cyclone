import 'dart:developer';
import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/home/pages/profile/profile_loader.dart';
import 'package:Siuu/pages/message/components/UserAvatar.dart';
import 'package:Siuu/pages/message/screens/conversation/components/messages_list/widgets/quoted_message_dialog.dart';
import 'package:Siuu/pages/message/screens/conversation/components/messages_list/widgets/react_button.dart';
import 'package:Siuu/pages/message/screens/conversation/components/messages_list/widgets/readed_icon.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../quoted_message.dart';
import 'content.dart';
import 'date_separator.dart';

class MessageItem extends StatelessWidget {
  Offset _tapPosition = Offset(0, 0);
  final Message nextMessage;
  final Message currentMessage;
  bool isMe;
  final ChatUser user;
  final double width;
  final AutoScrollController scrollController;
  final int index;
  final double horizontalPadding = 12;
  final double avatarSize = 40;

  MessageItem({
    @required this.currentMessage,
    @required this.nextMessage,
    @required this.width,
    @required this.user,
    @required this.scrollController,
    @required this.index,
  }) {
    isMe = currentMessage.isMe;
  }

  bool withAvatar = false;
  double maxWidth;

  @override
  Widget build(BuildContext context) {
    withAvatar = !isMe &&
        isWithAvatar(nextMessage: nextMessage, currentMessage: currentMessage);
    maxWidth =
        (width - (horizontalPadding * 2)) - (withAvatar ? avatarSize + 8 : 0);
    return AutoScrollTag(
      child: SwipeTo(
        onRightSwipe: () {
          context.read<ReplyCubit>().reply(currentMessage);
          FocusScope.of(context)
              .requestFocus(context.read<ReplyCubit>().textFocus);
        },
        child: GestureDetector(
          onTapDown: _storePosition,
          onLongPress: () => _showMenu(context),
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                DateSeparator(
                    currentMessage: currentMessage, nextMessage: nextMessage),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (currentMessage.isMe && currentMessage.hasReaction)
                          Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 8),
                              child: Container(
                                height: 20,
                                width: 20,
                                child: CachedNetworkImage(
                                  imageUrl: currentMessage.reaction,
                                  placeholder: (_, __) => Container(),
                                  errorWidget: (_, ___, __) => Container(),
                                  fadeOutDuration: Duration(milliseconds: 100),
                                ),
                              )),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (withAvatar)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ProfileLoader(
                                              userId: int.parse(user.id)),
                                        ),
                                      );
                                    },
                                    child: UserAvatar(
                                      user: user,
                                      size: avatarSize,
                                    ),
                                  ),
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (isWithTime(
                                      nextMessage: nextMessage,
                                      currentMessage: currentMessage))
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        dateToTime(
                                          context,
                                          date: currentMessage.dateTime,
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  if (currentMessage.quotedMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: GestureDetector(
                                        onTap: () => scrollToQuoted(context),
                                        child: QuoteMessage(
                                          maxWidth: maxWidth,
                                          msg: currentMessage.quotedMessage,
                                          senderName:
                                              currentMessage.quotedMessage.isMe
                                                  ? 'You'
                                                  : user.name,
                                        ),
                                      ),
                                    ),
                                  ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: maxWidth),
                                    child: Content(message: currentMessage),
                                  )
                                ],
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(vertical: 2),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: horizontalPadding),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Color.fromRGBO(252, 246, 246, 1)
                                : Colors.grey.withOpacity(0.2),
                            borderRadius: isMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                          ),
                        ),
                        ReactButton(currentMessage)
                      ],
                    ),
                    ReadedIcon(
                      msgId: currentMessage.id,
                      user: user,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        iconColor: Color(pinkColor),
        offsetDx: 0.2,
      ),
      key: ValueKey(index),
      highlightColor: Color(pinkColor).withOpacity(0.4),
      controller: scrollController,
      index: index,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void scrollToQuoted(BuildContext context) {
    final ConversationLoadSuccess state =
        context.read<ConversationBloc>().state is ConversationLoadSuccess
            ? context.read<ConversationBloc>().state
            : null;

    if (state != null) {
      final int index = (state.messages.indexWhere(
          (element) => element.id == currentMessage.quotedMessage.id));
      log(index.toString());
      if (index != -1) {
        scrollController
            .scrollToIndex(index, preferPosition: AutoScrollPosition.middle)
            .then(
              (value) => scrollController.highlight(
                index,
                animated: true,
                highlightDuration: Duration(milliseconds: 200),
              ),
            );
      } else {
        FocusScope.of(context).unfocus();
        Message q_msg = currentMessage.quotedMessage;
        showQuotedDialog(context, q_msg, user.name);
      }
    }
  }

  void _showMenu(BuildContext context) {
    if (!currentMessage.isMe && !currentMessage.isText) return;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    FocusScope.of(context).unfocus();
    showMenu(
      items: [
        if (currentMessage.isText)
          PopupMenuItem(
            value: 0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.copy_rounded,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text("Copy Text"),
              ],
            ),
          ),
        if (currentMessage.isMe)
          PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                SizedBox(width: 4),
                Text("Delete"),
              ],
            ),
          )
      ],
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
    ).then((value) {
      if (value == 0) {
        Clipboard.setData(ClipboardData(text: currentMessage.text));
        Fluttertoast.showToast(
            msg: "Copied to clipboard",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.withOpacity(0.8),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (value == 1) {
        context.read<ConversationBloc>().add(MessageDeleted(currentMessage));
      }
    });
  }
}

bool isWithTime(
    {@required Message nextMessage, @required Message currentMessage}) {
  if (nextMessage == null) {
    return true;
  } else {
    if (nextMessage.senderId != currentMessage.senderId) {
      return true;
    } else {
      if (!isSameTime(nextMessage.dateTime, currentMessage.dateTime)) {
        return true;
      } else {
        return false;
      }
    }
  }
}

bool isWithAvatar(
    {@required Message nextMessage, @required Message currentMessage}) {
  if (nextMessage == null) {
    return true;
  } else {
    if (nextMessage.senderId == currentMessage.senderId) {
      return false;
    } else {
      return true;
    }
  }
}

bool isSameTime(DateTime date1, DateTime date2) {
  TimeOfDay time1 = TimeOfDay.fromDateTime(date1);
  TimeOfDay time2 = TimeOfDay.fromDateTime(date2);

  return time1 == time2;
}
