import 'dart:math';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/res/shared_variables.dart';
import 'package:Siuu/widgets/avatars/letter_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final ChatUser user;
  final double size;

  UserAvatar({@required this.user, this.size =70});

  @override
  Widget build(BuildContext context) {
    if (user == null)
      return Container(
        width: 70,
        height: 70,
        child: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/images/place_hoder.png')),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      );

    if (size != null) {
      return Container(
        width: size,
        height: size,
        child: CircleAvatar(
          radius: 35,
          backgroundImage: user == null ||
                  user.imageUrl == null ||
                  user.imageUrl.isEmpty
              ? AssetImage('assets/images/place_hoder.png')
              : CachedNetworkImageProvider(user.imageUrl),
        ),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      );
    }
  //   if (!user.hasProfileAvatar())
  //     return addCircle(
  //       userId: user.id,
  //       child: OBLetterAvatar(
  //         color: Color(pinkColor),
  //         letter: user.username[0],
  //         borderRadius: 30,
  //         customSize: OBLetterAvatar.fontSizeLarge,
  //         labelColor: Colors.white,
  //         size: OBAvatarSize.small,
  //       ),
  //     );
  //
  //   return addCircle(
  //     userId: user.id,
  //     child: OBAvatar(
  //       size: OBAvatarSize.small,
  //       avatarUrl: user.getProfileAvatar(),
  //     ),
  //   );
  }

  Widget addCircle({int userId, Widget child}) {
    final isAllViewed =
        SharedVariables.controlIsAllStoriesViewedFromUserId(userId.toString());
    return Container(
      child: Container(
        decoration: isAllViewed != null
            ? BoxDecoration(
                shape: BoxShape.circle,
                gradient: isAllViewed ? allViewedGradient : linearGradient,
              )
            : BoxDecoration(
                color: Colors.transparent,
              ),
        padding: isAllViewed != null ? const EdgeInsets.all(2.0) : null,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: isAllViewed != null ? const EdgeInsets.all(2.0) : null,
          child: child,
        ),
      ),
    );
  }
}
