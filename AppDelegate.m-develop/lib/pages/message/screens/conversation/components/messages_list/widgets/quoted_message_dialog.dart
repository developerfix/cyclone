import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'custom_image.dart';

showQuotedDialog(BuildContext context, Message q_msg, String userName) {
  showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            q_msg.isMe ? 'You' : userName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(pinkColor),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                fullDate(context, date: q_msg.dateTime),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      getQuotedMessage(q_msg)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Widget getQuotedMessage(Message message) {
  if (message.isImage) {
    if (message.imageUrl != null || message.temporaryImagePath != null)
      return Center(
        child: CustomImage(
          message.imageUrl ?? message.temporaryImagePath,
          message.imageUrl == null,
        ),
      );
  }

  if (message.isAudio) {
    if (message.audioDuration != null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.mic),
          Text(
            'Voice message (${printDuration(Duration(milliseconds: message.audioDuration))})',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(),
          )
        ],
      );
  }
  if (message.isLottie)
    return Center(
      child: Container(
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
      ),
    );
  return Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Text(message.text),
  );
}
