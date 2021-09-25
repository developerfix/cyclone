import 'package:Siuu/models/emoji.dart';
import 'package:Siuu/models/emoji_group.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_comment_reaction.dart';
import 'package:Siuu/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/emoji_picker/emoji_picker.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReactToPostCommentBottomSheet extends StatefulWidget {
  final PostComment postComment;
  final Post post;

  const OBReactToPostCommentBottomSheet({this.post, this.postComment});

  @override
  State<StatefulWidget> createState() {
    return OBReactToPostCommentBottomSheetState();
  }
}

class OBReactToPostCommentBottomSheetState
    extends State<OBReactToPostCommentBottomSheet> {
  UserService _userService;
  ToastService _toastService;

  bool _isReactToPostCommentInProgress;
  CancelableOperation _reactOperation;

  @override
  void initState() {
    super.initState();
    _isReactToPostCommentInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_reactOperation != null) _reactOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    double screenHeight = MediaQuery.of(context).size.height;

    return OBRoundedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: screenHeight / 3,
            child: IgnorePointer(
              ignoring: _isReactToPostCommentInProgress,
              child: Opacity(
                opacity: _isReactToPostCommentInProgress ? 0.5 : 1,
                child: OBEmojiPicker(
                  hasSearch: false,
                  isReactionsPicker: true,
                  onEmojiPicked: _reactToPostComment,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _reactToPostComment(Emoji emoji, EmojiGroup emojiGroup) async {
    if (_isReactToPostCommentInProgress) return null;
    _setReactToPostCommentInProgress(true);

    try {
      _reactOperation = CancelableOperation.fromFuture(
          _userService.reactToPostComment(
              post: widget.post,
              postComment: widget.postComment,
              emoji: emoji));

      PostCommentReaction postCommentReaction = await _reactOperation.value;
      widget.postComment.setReaction(postCommentReaction);
      // Remove modal
      Navigator.pop(context);
      _setReactToPostCommentInProgress(false);
    } catch (error) {
      _onError(error);
      _setReactToPostCommentInProgress(false);
    } finally {
      _reactOperation = null;
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

  void _setReactToPostCommentInProgress(bool reactToPostCommentInProgress) {
    setState(() {
      _isReactToPostCommentInProgress = reactToPostCommentInProgress;
    });
  }
}

typedef void OnPostCommentCreatedCallback(PostCommentReaction reaction);
