import 'dart:io';
import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class QuoteMessage extends StatelessWidget {
  final String senderName;
  final Message msg;
  final bool fromComposer;
  final double maxWidth;

  const QuoteMessage({
    @required this.senderName,
    @required this.msg,
    this.maxWidth,
    this.fromComposer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                senderName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(pinkColor),
                ),
              ),
              if (fromComposer)
                GestureDetector(
                  onTap: BlocProvider.of<ReplyCubit>(context).closeReply,
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Colors.grey,
                  ),
                )
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: maxWidth != null ? (maxWidth - 20) : double.infinity),
            child: Padding(
              padding: EdgeInsets.only(right: fromComposer ? 18 : 0, top: 4),
              child: QuotedContent(msg: msg),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.09),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    );
  }
}

class QuotedContent extends StatelessWidget {
  const QuotedContent({@required this.msg});

  final Message msg;

  @override
  Widget build(BuildContext context) {
    if (msg.isAudio) {
      if (msg.audioDuration != null)
        return Row(
          children: <Widget>[
            Icon(Icons.mic),
            Expanded(
              child: Text(
                'Voice message (${printDuration(Duration(milliseconds: msg.audioDuration))})',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(),
              ),
            )
          ],
        );
    }
    if (msg.isImage) {
      if (msg.temporaryImagePath != null)
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 60),
            child: FadeInImage(
              image: FileImage(File(msg.temporaryImagePath)),
              placeholder: AssetImage('assets/images/place_hoder.png'),
              imageErrorBuilder: (_, __, ___) =>
                  Image.asset('assets/images/place_hoder.png'),
              fadeOutDuration: Duration(milliseconds: 100),
            ),
          ),
        );

      if (msg.imageUrl != null)
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 60),
            child: CachedNetworkImage(
              imageUrl: msg.imageUrl,
              placeholder: (_, __) =>
                  Image.asset('assets/images/place_hoder.png'),
              errorWidget: (_, __, ___) =>
                  Image.asset('assets/images/place_hoder.png'),
              fadeOutDuration: Duration(milliseconds: 100),
            ),
          ),
        );
    }

    if (msg.isLottie)
      return Container(
        height: 60,
        child: Lottie.asset(msg.lottiePath, errorBuilder: (_, __, ___) {
          return Center(
            child: Icon(
              Icons.error_outline_outlined,
              size: 40,
              color: Colors.grey,
            ),
          );
        }),
      );
    return Container(
      child: Text(
        msg.text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(),
      ),
    );
  }
}
