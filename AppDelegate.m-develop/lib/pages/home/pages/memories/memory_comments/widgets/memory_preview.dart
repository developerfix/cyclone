import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/story/story_view.dart';
import 'package:Siuu/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Siuu/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Siuu/widgets/post/widgets/post-body/post_body.dart';
import 'package:Siuu/widgets/post/widgets/post_circles.dart';
import 'package:Siuu/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Siuu/widgets/post/widgets/post_header/post_header.dart';
import 'package:Siuu/widgets/post/widgets/post_reactions.dart';
import 'package:Siuu/widgets/theming/post_divider.dart';
import 'package:flutter/material.dart';

class MemoryPreview extends StatelessWidget {
  final StoryItem storyItem;
  final Story story;
  final Function(Story) onMomentDeleted;
  final VoidCallback focusCommentInput;
  final bool showViewAllCommentsAction;

  MemoryPreview({
    @required this.story,
    @required this.storyItem,
    this.onMomentDeleted,
    this.focusCommentInput,
    this.showViewAllCommentsAction = true,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height / 100 * 25,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: storyItem.view,
    );
  }
}
