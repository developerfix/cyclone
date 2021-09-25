import 'dart:developer';
import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/cubit/audioplayer_cubit.dart';
import 'package:Siuu/cubit/recordaudio_cubit.dart';
import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/cubit/typing_cubit.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/home/pages/profile/profile_loader.dart';
import 'package:Siuu/pages/message/components/CustomAppBar.dart';
import 'package:Siuu/pages/message/components/custom_scaffold.dart';
import 'package:Siuu/pages/message/components/picker.dart';
import 'package:Siuu/repository/conversation_repository.dart';
import 'package:Siuu/utils/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/message_composer/message_composer.dart';
import 'components/messages_list/messages_list.dart';

bool conversationIsActive = false;

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation>
    with WidgetsBindingObserver {
  ChatUser user;
  ConversationRepository repository = ConversationRepository();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      conversationIsActive = false;
      context.read<TypingCubit>().toggleTyping(false);
      repository.updateChattingWith(null);
    } else if (state == AppLifecycleState.resumed) {
      conversationIsActive = true;
      context.read<ConversationBloc>().add(MessagesReaded());
      repository.updateChattingWith(user.id);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    conversationIsActive = true;
    log('initState');
    WidgetsBinding.instance.addObserver(this);
    user = context.read<ConversationBloc>().reciever;
    context.read<ConversationBloc>().add(ConversationLoaded());
    context.read<TypingCubit>().toggleTyping(false);
    repository.updateChattingWith(user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext cnt) {
    return WillPopScope(
      onWillPop: () async {
        if (context.read<ReplyCubit>().textFocus.hasFocus) {
          FocusScope.of(context).unfocus();
          return false;
        }
        close();
        return false;
      },
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: conversationAppBar(cnt),
        body: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Expanded(
                  child: MessagesList(user: user),
                ),
                MessageComposer(user: user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomAppBar conversationAppBar(cnt) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          close();
        },
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            user.name,
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
          BlocBuilder<TypingCubit, TypingState>(
            builder: (_, state) {
              bool isWriting = state is TypingTrue;
              return !isWriting
                  ? Container()
                  : Text(
                      'Typing...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    );
            },
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: PopupMenuButton(
            child: GestureDetector(
              child: Icon(
                Icons.more_horiz,
                size: 30.0,
                color: Colors.white,
              ),
            ),
            onSelected: (index) {
              switch (index) {
                case 0:
                  return context.read<RecordAudioCubit>().startRecord(context);
                case 1:
                  return sendImage(ImageType.Gallery, context);
                case 2:
                  return sendLottie(context);
                case 3:
                // return 33;
              }
            },
            itemBuilder: (_) => [0, 1, 2, 3]
                .map(
                  (e) => PopupMenuItem(
                    value: e,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          e == 0
                              ? Icons.mic_rounded
                              : e == 1
                                  ? Icons.image_outlined
                                  : e == 2
                                      ? Icons.insert_emoticon_outlined
                                      : Icons.account_circle_rounded,
                        ),
                        SizedBox(width: 8),
                        Text(
                          e == 0
                              ? "Record Audio"
                              : e == 1
                                  ? "Send Image"
                                  : e == 2
                                      ? "Send Sticker"
                                      : "View Profile",
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
      ],
    );
  }

  void close() {
    log('closeeee');
    conversationIsActive = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    context.read<AudioPlayerCubit>().close();
    ConversationRepository.toggleIsTyping(user.id, false);
    repository.updateChattingWith(null);
    WidgetsBinding.instance.removeObserver(this);
    Navigator.of(context).pop();
  }
}
