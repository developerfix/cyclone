import 'package:Siuu/models/emoji.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_comment_reaction.dart';
import 'package:Siuu/models/reactions_emoji_count.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/reaction_emoji_count.dart';
import 'package:flutter/material.dart';

class OBPostCommentReactions extends StatefulWidget {
  final PostComment postComment;
  final Post post;

  OBPostCommentReactions({@required this.post, @required this.postComment});

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentReactionsState();
  }
}

class OBPostCommentReactionsState extends State<OBPostCommentReactions> {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;

    return StreamBuilder(
        stream: widget.postComment.updateSubject,
        initialData: widget.postComment,
        builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
          var postComment = snapshot.data;

          List<ReactionsEmojiCount> emojiCounts =
              postComment.reactionsEmojiCounts?.counts ?? [];

          if (emojiCounts.isEmpty) return const SizedBox();

          return Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 30,
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                itemCount: emojiCounts.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  ReactionsEmojiCount emojiCount = emojiCounts[index];

                  return OBEmojiReactionButton(
                    emojiCount,
                    size: OBEmojiReactionButtonSize.small,
                    reacted: widget.postComment.isReactionEmoji(emojiCount.emoji),
                    onPressed: _onEmojiReactionCountPressed,
                    onLongPressed: (pressedEmojiCount) {
                      _navigationService.navigateToPostCommentReactions(
                          post: widget.post,
                          postComment: widget.postComment,
                          reactionsEmojiCounts: emojiCounts,
                          context: context,
                          reactionEmoji: pressedEmojiCount.emoji);
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  void _onEmojiReactionCountPressed(
      ReactionsEmojiCount pressedEmojiCount) async {
    bool isReactionEmoji =
        widget.postComment.isReactionEmoji(pressedEmojiCount.emoji);

    if (isReactionEmoji) {
      await _deleteReaction();
      widget.postComment.clearReaction();
    } else {
      // React
      PostCommentReaction newPostCommentReaction =
          await _reactToPostComment(pressedEmojiCount.emoji);
      widget.postComment.setReaction(newPostCommentReaction);
    }
  }

  Future<PostCommentReaction> _reactToPostComment(Emoji emoji) async {
    PostCommentReaction postCommentReaction;
    try {
      postCommentReaction = await _userService.reactToPostComment(
          post: widget.post, postComment: widget.postComment, emoji: emoji);
    } catch (error) {
      _onError(error);
    }

    return postCommentReaction;
  }

  Future<void> _deleteReaction() async {
    try {
      await _userService.deletePostCommentReaction(
          postCommentReaction: widget.postComment.reaction,
          post: widget.post,
          postComment: widget.postComment);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }
}
