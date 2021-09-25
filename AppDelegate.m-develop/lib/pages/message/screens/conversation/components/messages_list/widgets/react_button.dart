import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/widgets/emoji_picker/emoji_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReactButton extends StatelessWidget {
  final Message currentMessage;

  const ReactButton(this.currentMessage);

  @override
  Widget build(BuildContext context) {
    if (!currentMessage.isMe) {
      if (currentMessage.isAudio && (currentMessage.audioUrl == null))
        return Container();

      if (currentMessage.isImage && (currentMessage.imageUrl == null))
        return Container();
      return Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        child: InkWell(
          onTap: () => react(
            context,
            onReact: (emoji) {
              context
                  .read<ConversationBloc>()
                  .add(MessageReacted(currentMessage, emoji));
            },
          ),
          child: currentMessage.hasReaction
              ? Container(
                  height: 20,
                  width: 20,
                  child: CachedNetworkImage(
                    imageUrl: currentMessage.reaction,
                    placeholder: (_, __) => Container(),
                    errorWidget: (_, ___, __) => Container(),
                    fadeOutDuration: Duration(milliseconds: 100),
                  ),
                )
              : Icon(
                  Icons.insert_emoticon_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
        ),
      );
    }
    return Container();
  }

  void react(BuildContext context, {Function(String emoji) onReact}) {
    if (currentMessage.hasReaction)
      onReact(null);
    else
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return Container(
              height: 300,
              width: double.infinity,
              child: Center(
                child: OBEmojiPicker(
                  hasSearch: false,
                  isReactionsPicker: true,
                  onEmojiPicked: (e, __) {
                    Navigator.pop(context);
                    onReact(e.image);
                  },
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
            );
          });
  }
}
