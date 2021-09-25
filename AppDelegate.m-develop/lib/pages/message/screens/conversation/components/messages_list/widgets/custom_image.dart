import 'dart:io';
import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/pages/message/components/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final bool isLocal;

  const CustomImage(this.path, this.isLocal);

  void openImage(BuildContext context) {
    ConversationState state = context.read<ConversationBloc>().state;

    if (state is ConversationLoadSuccess) {
      List<Message> messages = state.messages
          .where((m) =>
              m.isImage && (m.imageUrl != null || m.temporaryImagePath != null))
          .toList();
      showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.9),
        transitionDuration: Duration(milliseconds: 100),
        context: context,
        pageBuilder: (_, anim1, anim2) {
          return BlocProvider<ConversationBloc>.value(
            value: context.read<ConversationBloc>(),
            child: PhotoViewer(
              path: path,
              messages: messages,
              userId: context.read<ConversationBloc>().reciever.id,
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: path == null
          ? Container(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/images/place_hoder.png',
                fit: BoxFit.cover,
              ))
          : isLocal
              ? GestureDetector(
                  onTap: () => openImage(context),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 280),
                    child: FadeInImage(
                      image: FileImage(File(path)),
                      placeholder: AssetImage('assets/images/place_hoder.png'),
                      fadeOutDuration: Duration(milliseconds: 100),
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageBuilder: (_, img) {
                    return GestureDetector(
                      onTap: () => openImage(context),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 280),
                          child: Image(image: img)),
                    );
                  },
                  imageUrl: path,
                  placeholder: (_, __) =>
                      Image.asset('assets/images/place_hoder.png'),
                  fadeOutDuration: Duration(milliseconds: 100),
                ),
    );
  }
}
