import 'package:Siuu/models/notifications/notification.dart';
import 'package:Siuu/models/notifications/post_comment_reaction_notification.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_comment_reaction.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Siuu/widgets/theming/actionable_smart_text.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/tiles/notification_tile/notification_tile_post_media_preview.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBPostCommentReactionNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostCommentReactionNotification postCommentReactionNotification;
  static final double postCommentImagePreviewSize = 40;
  final VoidCallback onPressed;

  const OBPostCommentReactionNotificationTile(
      {Key key,
      @required this.notification,
      @required this.postCommentReactionNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostCommentReaction postCommentReaction =
        postCommentReactionNotification.postCommentReaction;
    PostComment postComment = postCommentReaction.postComment;
    Post post = postComment.post;

    Widget postCommentImagePreview;
    if (post.hasMediaThumbnail()) {
      postCommentImagePreview = OBNotificationTilePostMediaPreview(
        post: post,
      );
    }
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Function navigateToReactorProfile = () {
      openbookProvider.navigationService.navigateToUserProfile(
          user: postCommentReaction.reactor, context: context);
    };
    LocalizationService _localizationService =
        openbookProvider.localizationService;

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        PostComment parentComment = postComment.parentComment;
        if (parentComment != null) {
          openbookProvider.navigationService.navigateToPostCommentRepliesLinked(
              postComment: postComment,
              context: context,
              parentComment: parentComment);
        } else {
          openbookProvider.navigationService.navigateToPostCommentsLinked(
              postComment: postComment, context: context);
        }
      },
      leading: OBAvatar(
        onPressed: navigateToReactorProfile,
        size: OBAvatarSize.small,
        avatarUrl: postCommentReaction.reactor.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        text: TextSpan(
            text: _localizationService
                .notifications__reacted_to_post_comment_tile),
        onUsernamePressed: navigateToReactorProfile,
        user: postCommentReaction.reactor,
      ),
      subtitle: OBSecondaryText(
        utilsService.timeAgo(notification.created, _localizationService),
        size: OBTextSize.small,
      ),
      trailing: Row(
        children: <Widget>[
          OBEmoji(
            postCommentReaction.emoji,
          ),
          postCommentImagePreview ?? const SizedBox()
        ],
      ),
    );
  }
}
