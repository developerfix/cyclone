import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/screens/conversation/components/quoted_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReplyContainer extends StatefulWidget {
  final ChatUser user;

  const ReplyContainer(this.user);
  @override
  _ReplyContainerState createState() => _ReplyContainerState();
}

class _ReplyContainerState extends State<ReplyContainer>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReplyCubit, ReplyState>(
      builder: (_, ReplyState state) {
        return AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 200),
          child: state is ReplyEnable
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: QuoteMessage(
                    msg: state.msg,
                    senderName: state.msg.isMe ? 'You' : widget.user.name,
                    fromComposer: true,
                  ),
                )
              : Container(),
        );
      },
    );
  }
}
