import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/actionable_smart_text.dart';
import 'package:Siuu/widgets/theming/collapsible_smart_text.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MemoryCommentText extends StatefulWidget {
  final MomentComment momentComment;
  final Story story;
  final VoidCallback onUsernamePressed;
  final int postCommentMaxVisibleLength = 500;

  MemoryCommentText(this.momentComment, this.story,
      {Key key, this.onUsernamePressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MemoryCommentTextState();
  }
}

class MemoryCommentTextState extends State<MemoryCommentText> {
  String _translatedText;
  bool _requestInProgress;
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  bool isorignal = true;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState provider = OpenbookProvider.of(context);
    _toastService = provider.toastService;
    _userService = provider.userService;
    _localizationService = provider.localizationService;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onLongPress: () {
                  OpenbookProviderState openbookProvider =
                      OpenbookProvider.of(context);
                  Clipboard.setData(
                      ClipboardData(text: widget.momentComment.text));
                  openbookProvider.toastService.toast(
                      message: 'Text copied!',
                      context: context,
                      type: ToastType.info);
                },
                child: _getActionableSmartText(),
              ),
            ),
          ],
        )
      ],
    );
  }

  /*Widget _getPostCommentTranslateButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isorignal = !isorignal;
        });
      },
      child: !isorignal
          ? OBSecondaryText(_localizationService.user__translate_show_original,
              size: OBTextSize.large)
          : OBSecondaryText(
              _localizationService.user__translate_see_translation,
              size: OBTextSize.large),
    );

    // if (_requestInProgress) {
    //   return Padding(
    //       padding: EdgeInsets.all(10.0),
    //       child: Container(
    //         width: 10.0,
    //         height: 10.0,
    //         child: CircularProgressIndicator(strokeWidth: 2.0),
    //       ));
    // }
    //
    // User loggedInUser = _userService.getLoggedInUser();
    // if (loggedInUser != null &&
    //     loggedInUser.canTranslatePostComment(widget.postComment, widget.post)) {
    //   return GestureDetector(
    //     onTap: _toggleTranslatePostComment,
    //     child: _translatedText != null
    //         ? OBSecondaryText(
    //             _localizationService.user__translate_show_original,
    //             size: OBTextSize.large)
    //         : OBSecondaryText(
    //             _localizationService.user__translate_see_translation,
    //             size: OBTextSize.large),
    //   );
    // } else {
    //   return SizedBox();
    // }
  }*/

  /*void _toggleTranslatePostComment() async {
    try {
      if (_translatedText == null) {
        _setRequestInProgress(true);
        CancelableOperation<String> _getTranslationOperation =
            CancelableOperation.fromFuture(_userService.translatePostComment(
          postComment: widget.postComment,
          post: widget.post,
        ));

        String translatedText = await _getTranslationOperation.value;
        _setPostCommentTranslatedText(translatedText);
      } else {
        _setPostCommentTranslatedText(null);
      }
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }*/

  Widget _getActionableSmartText() {
    return OBCollapsibleSmartText(
      size: OBTextSize.large,
      text: widget.momentComment.text,
      maxlength: widget.postCommentMaxVisibleLength,
      getChild: () => OBSecondaryText("", size: OBTextSize.large),
      hashtagsMap: {},
    );
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

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setPostCommentTranslatedText(String newText) {
    setState(() {
      _translatedText = newText;
    });
  }
}