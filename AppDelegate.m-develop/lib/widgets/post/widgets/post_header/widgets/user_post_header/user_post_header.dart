import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/bottom_sheets/post_actions.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/res/shared_variables.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/letter_avatar.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/post/post.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/user_badge.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OBUserPostHeader extends StatelessWidget {
  final Post _post;
  final OnPostDeleted onPostDeleted;
  final ValueChanged<Post> onPostReported;
  final OBPostDisplayContext displayContext;
  final bool hasActions;
  final bool onlypost;

  final bool isShare;
  final bool showelipsororignal;
  final Color shareBoxColor;

  const OBUserPostHeader(
      this._post, {
        Key key,
        @required this.onPostDeleted,
        @required this.onlypost,
        @required this.showelipsororignal,
        @required this.isShare,
        this.onPostReported,
        this.hasActions = true,
        this.displayContext,
        this.shareBoxColor,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;
    var bottomSheetService = openbookProvider.bottomSheetService;
    var utilsService = openbookProvider.utilsService;
    var localizationService = openbookProvider.localizationService;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    if (_post.creator == null) return const SizedBox();

    String username = '${_post.creator.username}';
    String shareusername = '';
    String timeAgo = '';
    String timeAgoshare = '';
    String shareText = null;
    bool isspcialtext = false;
    if (_post.created != null)
      timeAgo =
      '${utilsService.timeAgo(_post.created, localizationService)} agos';

    if (isShare) {
      timeAgoshare =
      '${utilsService.timeAgo(_post.sharepostData.postDetails.createdAt, localizationService)} agos';
      shareusername = '${_post.sharepostData.sharedUserDetails.name}';
      print(
          "yessssssss text acheched::${_post.sharepostData.sharedUserDetails.userId}");
      print(
          "yessssssss text acheched:1:${_post.sharepostData.postDetails.shareType}");

      if (_post.sharepostData.postDetails.textAttached != null) {
        shareText = _post.sharepostData.postDetails.textAttached.toString();
        isspcialtext = true;
      }

      // print("this is share username::${_post.share_story_data.sharedPost[0].name}");
    }
    // timeAgoshare =
    // '${utilsService.timeAgo(_post.share_story_data.sharedPost[0].createdAt, localizationService)} agos';

    Function navigateToUserProfile = () {
      navigationService.navigateToUserProfile(
          user: _post.creator, context: context);
    };
    return Container(
      margin: _post.sharepostData == null
          ? const EdgeInsets.fromLTRB(10, 10, 10, 0)
          : isShare
          ? const EdgeInsets.fromLTRB(10, 10, 10, 0)
          : const EdgeInsets.fromLTRB(10, 7.5, 10, 0),
      decoration: (!isShare && _post.sharepostData != null)
          ? BoxDecoration(
        border: Border(
          left: BorderSide(
            color: shareBoxColor,
            width: 1,
            style: BorderStyle.solid,
          ),
          right: BorderSide(
            color: shareBoxColor,
            width: 1,
            style: BorderStyle.solid,
          ),
          top: BorderSide(
            color: shareBoxColor,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      )
          : null,
      child: Padding(
        padding: _post.sharepostData == null
            ? const EdgeInsets.fromLTRB(10, 10, 10, 0)
            : isShare
            ? const EdgeInsets.fromLTRB(10, 10, 10, 0)
            : const EdgeInsets.fromLTRB(20, 7.5, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      if (!isShare) navigateToUserProfile();
                    },
                    child: StreamBuilder(
                        stream: _post.creator.updateSubject,
                        initialData: _post.creator,
                        builder: (BuildContext context,
                            AsyncSnapshot<User> snapshot) {
                          User postCreator = snapshot.data;

                          if (isShare) {
                            if (_post.sharepostData.sharedUserDetails.avatar !=
                                null) {
                              return addCircle(
                                userId: _post
                                    .sharepostData.sharedUserDetails.userId,
                                child: OBAvatar(
                                  size: OBAvatarSize.extraSmall,
                                  avatarUrl: _post
                                      .sharepostData.sharedUserDetails.avatar,
                                ),
                              );
                            } else {
                              return addCircle(
                                userId: _post
                                    .sharepostData.sharedUserDetails.userId,
                                child: OBLetterAvatar(
                                  color: Color(pinkColor),
                                  letter: _post.sharepostData.sharedUserDetails
                                      .name !=
                                      null
                                      ? _post.sharepostData.sharedUserDetails
                                      .name[0]
                                      : "U",
                                  borderRadius: 30,
                                  customSize: OBLetterAvatar.fontSizeLarge,
                                  labelColor: Colors.white,
                                  size: OBAvatarSize.extraSmall,
                                ),
                              );
                            }
                          }

                          if (!postCreator.hasProfileAvatar())
                            return addCircle(
                              userId: postCreator.id,
                              child: OBLetterAvatar(
                                color: Color(pinkColor),
                                letter: postCreator.username[0],
                                borderRadius: 30,
                                customSize: OBLetterAvatar.fontSizeLarge,
                                labelColor: Colors.white,
                                size: OBAvatarSize.extraSmall,
                              ),
                            );

                          return addCircle(
                            userId: postCreator.id,
                            child: OBAvatar(
                              size: OBAvatarSize.extraSmall,
                              avatarUrl: postCreator.getProfileAvatar(),
                            ),
                          );
                        })),
                SizedBox(width: width * 0.024),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isShare
                        ? Row(
                      children: [
                        Text(
                          isShare ? shareusername : username,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Segoe UI",
                            fontSize: 17,
                            color: Color(0xff78849e),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        /*  Text(
                        "share this post",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff0a0a0a).withOpacity(0.56),
                        ),
                      ),*/
                      ],
                    )
                        : Text(
                      isShare ? shareusername : username,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 17,
                        color: Color(0xff78849e),
                      ),
                    ),
                    Text(
                      isShare ? timeAgoshare : timeAgo,
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xff78849e).withOpacity(0.56),
                      ),
                    ),
                    isShare && isspcialtext
                        ? Text(
                      shareText,
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xff0f0f10).withOpacity(0.56),
                      ),
                    )
                        : Container()
                  ],
                ),
              ],
            ),
            hasActions
                ? InkWell(
              //  child: Image.asset('assets/images/arrowDownIcon.png'),
                child: Container(
                  height: 14,
                  width: 18,
                  child: isShare && !onlypost
                      ? SvgPicture.asset('assets/svg/ellipsis.svg')
                      : onlypost && !isShare && showelipsororignal
                      ? SvgPicture.asset('assets/svg/ellipsis.svg')
                      : Container(),
                ),
                onTap: () {
                  bottomSheetService.showPostActions(
                      context: context,
                      post: _post,
                      onPostDeleted: onPostDeleted,
                      displayContext: displayContext,
                      onPostReported: onPostReported);
                })
                : null,
          ],
        ),
      ),
    );
    /* return ListTile(
        onTap: navigateToUserProfile,
        leading: StreamBuilder(
            stream: _post.creator.updateSubject,
            initialData: _post.creator,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              User postCreator = snapshot.data;

              if (!postCreator.hasProfileAvatar()) return const SizedBox();

              return OBAvatar(
                size: OBAvatarSize.medium,
                avatarUrl: postCreator.getProfileAvatar(),
              );
            }),
        trailing: hasActions
            ? IconButton(
                icon: const OBIcon(OBIcons.moreVertical),
                onPressed: () {
                  bottomSheetService.showPostActions(
                      context: context,
                      post: _post,
                      onPostDeleted: onPostDeleted,
                      displayContext: displayContext,
                      onPostReported: onPostReported);
                })
            : null,
        title: Row(
          children: <Widget>[
            Flexible(
              child: OBText(
                _post.creator.getProfileName(),
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            _buildBadge()
          ],
        ),
        subtitle: OBSecondaryText(
          subtitle,
          style: TextStyle(fontSize: 12.0),
        ));*/
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

  Widget _buildBadge() {
    User postCommenter = _post.creator;

    if (postCommenter.hasProfileBadges())
      return OBUserBadge(
          badge: _post.creator.getDisplayedProfileBadge(),
          size: OBUserBadgeSize.small);

    return const SizedBox();
  }
}
