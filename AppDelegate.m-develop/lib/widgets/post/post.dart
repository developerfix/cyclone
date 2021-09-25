import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Siuu/widgets/post/widgets/post-body/post_body.dart';
import 'package:Siuu/widgets/post/widgets/post-body/widgets/post_body_text.dart';
import 'package:Siuu/widgets/post/widgets/post_circles.dart';
import 'package:Siuu/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Siuu/widgets/post/widgets/post_header/post_header.dart';
import 'package:Siuu/widgets/post/widgets/post_reactions.dart';
import 'package:Siuu/widgets/theming/post_divider.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'dart:developer';

class OBPost extends StatelessWidget {
  final Post post;
  final ValueChanged<Post> onPostDeleted;
  final ValueChanged<Post> onPostIsInView;
  final OnTextExpandedChange onTextExpandedChange;
  final String inViewId;
  final Function onMemoryExcluded;
  final Function onUndoMemoryExcluded;
  final ValueChanged<Memory> onPostMemoryExcludedFromProfilePosts;
  final OBPostDisplayContext displayContext;

  const OBPost(this.post,
      {Key key,
      @required this.onPostDeleted,
      this.onPostIsInView,
      this.onMemoryExcluded,
      this.onUndoMemoryExcluded,
      this.onTextExpandedChange,
      this.inViewId,
      this.displayContext = OBPostDisplayContext.timelinePosts,
      this.onPostMemoryExcludedFromProfilePosts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String postInViewId;
    if (this.displayContext == OBPostDisplayContext.topPosts)
      postInViewId = inViewId + '_' + post.id.toString();

    // log("this is share post::${post.share_story_data.sharedPost[0].name}");
    // log("this is share post::${post.share_story_data.sharedPost[1].name}");
    // log("this is share post::${post.share_story_data.sharedPost[2].name}");

    _bootstrap(context, postInViewId);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final Color shareBoxColor = Colors.grey[300];
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              // height: height * 0.357,
              // height: 126,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.00, 4.00),
                    color: Color(0xff455b63).withOpacity(0.08),
                    blurRadius: 16,
                  ),
                ],
                borderRadius: BorderRadius.circular(12.00),
              ),
              child: Column(
                //  fixme abubakar set share user data
                children: [
                  post.sharepostData != null
                      ? OBPostHeader(
                          showelipsororignal: false,
                          post: post,
                          isShare: true,
                          onlypost: false,
                          onPostDeleted: onPostDeleted,
                          onPostReported: onPostDeleted,
                          displayContext: displayContext,
                          onMemoryExcluded: onMemoryExcluded,
                          onUndoMemoryExcluded: onUndoMemoryExcluded,
                          onPostMemoryExcludedFromProfilePosts:
                              onPostMemoryExcludedFromProfilePosts,
                          shareBoxColor: shareBoxColor,
                        )
                      : Container(),
                  OBPostHeader(
                    post: post,
                    showelipsororignal:
                        post.sharepostData != null ? false : true,
                    isShare: false,
                    onlypost: true,
                    onPostDeleted: onPostDeleted,
                    onPostReported: onPostDeleted,
                    displayContext: displayContext,
                    onMemoryExcluded: onMemoryExcluded,
                    onUndoMemoryExcluded: onUndoMemoryExcluded,
                    onPostMemoryExcludedFromProfilePosts:
                        onPostMemoryExcludedFromProfilePosts,
                    shareBoxColor: shareBoxColor,
                  ),
                  OBPostBody(
                    post,
                    onTextExpandedChange: onTextExpandedChange,
                    inViewId: inViewId,
                    shareBoxColor: shareBoxColor,
                  ),

                  // OBPostCircles(post),
                  OBPostComments(
                    post,
                  ),
                  OBPostActions(
                    post,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OBPostDivider(),
                ],
              ),
            ),
            SizedBox(height: height * 0.014)
          ],
        ));
  }

  void _bootstrap(BuildContext context, String postInViewId) {
    InViewState _inViewState;
    if (postInViewId != null) {
      _inViewState = InViewNotifierList.of(context);
      _inViewState.addContext(context: context, id: postInViewId);

      if (this.displayContext == OBPostDisplayContext.topPosts) {
        _inViewState.addListener(
            () => _onInViewStateChanged(_inViewState, postInViewId));
      }
    }
  }

  void _onInViewStateChanged(InViewState _inViewState, String postInViewId) {
    final bool isInView = _inViewState.inView(postInViewId);
    if (isInView) {
      if (onPostIsInView != null) onPostIsInView(post);
    }
  }
}

enum OBPostDisplayContext {
  timelinePosts,
  topPosts,
  crewPosts,
  foreignProfilePosts,
  ownProfilePosts
}
