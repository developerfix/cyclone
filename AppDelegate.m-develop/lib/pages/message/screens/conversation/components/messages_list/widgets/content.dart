import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/pages/message/components/linkable_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'custom_audio_player.dart';
import 'custom_image.dart';

class Content extends StatelessWidget {
  final Message message;
  const Content({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isImage) {
      return CustomImage(
        message.imageUrl ?? message.temporaryImagePath,
        message.imageUrl == null,
      );
    }

    if (message.isAudio) {
      return CustomAudioPlayer(
        audioPath: message.audioUrl ?? message.temporaryAudioPath,
        durationInMillis: message.audioDuration,
      );
    }
    if (message.isLottie)
      return Container(
        height: 140,
        child: Lottie.asset(message.lottiePath, errorBuilder: (_, __, ___) {
          return Center(
            child: Icon(
              Icons.error_outline_outlined,
              size: 40,
              color: Colors.grey,
            ),
          );
        }),
      );

    return LinkableText(message: message);
  }
}
