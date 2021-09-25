import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/cubit/recordaudio_cubit.dart';
import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/components/picker.dart';
import 'package:Siuu/utils/chat_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageField extends StatefulWidget {
  final double height;

  MessageField({@required this.height});
  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  ChatUser user;

  @override
  void initState() {
    user = context.read<ConversationBloc>().reciever;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.height),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CupertinoButton(
            child: Icon(
              Icons.insert_emoticon_outlined,
              size: 25,
              color: Colors.grey,
            ),
            onPressed: () => sendLottie(context),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 160),
              child: TextField(
                focusNode: context.read<ReplyCubit>().textFocus,
                controller: context.read<ReplyCubit>().textController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Colors.black),
                autofocus: false,
                maxLines: null,
                onChanged: (s) {
                  context
                      .read<RecordAudioCubit>()
                      .toggleRecord(canRecord: s.isEmpty);
                },
                decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          BlocBuilder<RecordAudioCubit, RecordaudioState>(
            builder: (context, state) {
              if (state is RecordAudioReady)
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 25,
                          color: Colors.grey,
                        ),
                        onTap: () => sendImage(ImageType.Camera, context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        child: Icon(
                          Icons.image_outlined,
                          size: 25,
                          color: Colors.grey,
                        ),
                        onTap: () => sendImage(ImageType.Gallery, context),
                      ),
                    ),
                  ],
                );
              return Container();
            },
          ),
          SizedBox(width: 4)
        ],
      ),
    );
  }
}
