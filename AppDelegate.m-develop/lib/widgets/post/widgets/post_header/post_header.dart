import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/pages/home/bottom_sheets/post_actions.dart';
import 'package:Siuu/widgets/post/post.dart';
import 'package:Siuu/widgets/post/widgets/post_header/widgets/community_post_header/community_post_header.dart';
import 'package:Siuu/widgets/post/widgets/post_header/widgets/user_post_header/user_post_header.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final bool onlypost;
  final bool showelipsororignal;
  final bool isShare;
  final Post post;
  final OnPostDeleted onPostDeleted;
  final ValueChanged<Post> onPostReported;
  final bool hasActions;
  final OBPostDisplayContext displayContext;
  final Function onMemoryExcluded;
  final Function onUndoMemoryExcluded;
  final ValueChanged<Memory> onPostMemoryExcludedFromProfilePosts;
  final Color shareBoxColor;

  const OBPostHeader({
    this.isShare,
    this.onlypost,
    this.showelipsororignal,
    Key key,
    this.onPostDeleted,
    this.post,
    this.onPostReported,
    this.onMemoryExcluded,
    this.onUndoMemoryExcluded,
    this.hasActions = true,
    this.displayContext = OBPostDisplayContext.timelinePosts,
    this.onPostMemoryExcludedFromProfilePosts,
    this.shareBoxColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return post.isMemoryPost() &&
            displayContext != OBPostDisplayContext.crewPosts
        ? OBMemoryPostHeader(post,
            onPostDeleted: onPostDeleted,
            onPostReported: onPostReported,
            hasActions: hasActions,
            onMemoryExcluded: onMemoryExcluded,
            onUndoMemoryExcluded: onUndoMemoryExcluded,
            onPostMemoryExcludedFromProfilePosts:
                onPostMemoryExcludedFromProfilePosts,
            displayContext: displayContext)
        : OBUserPostHeader(
            post,
            showelipsororignal:
                showelipsororignal != null ? showelipsororignal : true,
            isShare: isShare != null ? isShare : false,
            onlypost: onlypost != null ? onlypost : true,
            onPostDeleted: onPostDeleted,
            onPostReported: onPostReported,
            displayContext: displayContext,
            hasActions: hasActions,
            shareBoxColor: shareBoxColor,
          );
  }
}
