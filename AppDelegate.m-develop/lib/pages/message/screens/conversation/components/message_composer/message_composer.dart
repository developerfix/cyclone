import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/cubit/typing_cubit.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/screens/conversation/components/message_composer/widgets/message_field.dart';
import 'package:Siuu/pages/message/screens/conversation/components/reply_container.dart';
import 'package:Siuu/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/send_button.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class MessageComposer extends StatefulWidget {
  final ChatUser user;

  const MessageComposer({@required this.user});

  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer>
    with SingleTickerProviderStateMixin {
  final double composerHeight = 58;
  double screenHeight;

  @override
  void initState() {
    super.initState();
    FocusNode node = context.read<ReplyCubit>().textFocus;
    node.addListener(() {
      context.read<TypingCubit>().toggleTyping(node.hasFocus);
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        context.read<TypingCubit>().toggleTyping(visible);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: composerHeight),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReplyContainer(widget.user),
                            MessageField(height: composerHeight),
                          ],
                        ),
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Color(accentColor2),
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: composerHeight + 8),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: SendButton(composerHeight: composerHeight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
