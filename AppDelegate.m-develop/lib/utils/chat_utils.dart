import 'dart:developer';
import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/consts/massage_consts.dart';
import 'package:Siuu/cubit/recordaudio_cubit.dart';
import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/pages/message/components/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void sendImage(ImageType op, BuildContext context) async {
  FocusScope.of(context).unfocus();
  String img = await Picker().pickImageType(op, context);
  if (img != null) {
    context.read<ConversationBloc>().add(
          MessageAdded(
            Message(
                text: 'Sent a image',
                type: Message_Image_Type,
                temporaryImagePath: img),
            context.read<ReplyCubit>().state,
          ),
        );
    context.read<ReplyCubit>().closeReply();
  }
}

void sendLottie(BuildContext context) async {
  FocusScope.of(context).unfocus();
  String path = await Picker().pickLottie(context);
  log(path.toString());
  if (path != null) {
    context.read<ConversationBloc>().add(
          MessageAdded(
            Message(
              text: 'Sent a sticker',
              type: Message_Lottie_Type,
              lottiePath: path,
            ),
            context.read<ReplyCubit>().state,
          ),
        );
    context.read<ReplyCubit>().closeReply();
  }
}

sendMessage(BuildContext context) {
  String msg = context.read<ReplyCubit>().textController.text.trim();
  if (msg.isNotEmpty) {
    context.read<ConversationBloc>().add(
          MessageAdded(
            Message(
              text: msg,
              type: Message_Text_Type,
            ),
            context.read<ReplyCubit>().state,
          ),
        );

    context.read<ReplyCubit>().closeReply();
    context.read<RecordAudioCubit>().toggleRecord(canRecord: true);
    context.read<ReplyCubit>().textController.text = '';
  }
}
