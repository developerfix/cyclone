import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/user_badge.dart';
import 'package:flutter/material.dart';

class MemoryCommentCommenterIdentifier extends StatelessWidget {
  final MomentComment momentComment;
  final Story story;
  final VoidCallback onUsernamePressed;

  static int postCommentMaxVisibleLength = 500;

  MemoryCommentCommenterIdentifier({
    Key key,
    @required this.onUsernamePressed,
    @required this.momentComment,
    @required this.story,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var utilsService = openbookProvider.utilsService;
    var localizationService = openbookProvider.localizationService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          OBTheme theme = snapshot.data;

          Color secondaryTextColor =
              themeValueParserService.parseColor(theme.secondaryTextColor);

          String commenterUsername =
              momentComment?.commenter?.username ?? momentComment.name;
          String commenterName =
              momentComment?.commenter?.getProfileName() ?? "";
          String created =
              utilsService.timeAgo(momentComment.time, localizationService);

          return Opacity(
            opacity: 0.8,
            child: GestureDetector(
              onTap: onUsernamePressed,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(
                              color: secondaryTextColor, fontSize: 14),
                          children: [
                            TextSpan(
                                text: '$commenterName',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: ' @$commenterUsername',
                                style: TextStyle(fontSize: 12)),
                          ]),
                    ),
                  ),
                  _buildBadge(),
                  OBSecondaryText(
                    ' · $created',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBadge() {
    User postCommenter = momentComment.commenter;

    List<Widget> badges = [];

    if (postCommenter?.hasProfileBadges() == true)
      badges.add(_buildProfileBadge());

    return badges.isNotEmpty
        ? Row(
            children: badges,
          )
        : const SizedBox();
  }

  Widget _buildProfileBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: OBUserBadge(
          badge: momentComment.commenter.getDisplayedProfileBadge(),
          size: OBUserBadgeSize.small),
    );
  }
}
