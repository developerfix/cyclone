import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_comment_reaction.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/bottom_sheet.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class MemoryCommentActions extends StatefulWidget {
  final ValueChanged<PostComment> onReplyDeleted;
  final ValueChanged<PostComment> onReplyAdded;
  final ValueChanged<PostComment> onPostCommentDeleted;
  final ValueChanged<PostComment> onPostCommentReported;
  final Post post;
  final PostComment postComment;
  final bool showReplyAction;

  const MemoryCommentActions(
      {Key key,
      @required this.post,
      @required this.postComment,
      this.onReplyDeleted,
      this.onReplyAdded,
      this.onPostCommentDeleted,
      this.onPostCommentReported,
      this.showReplyAction = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MemoryCommentActionsState();
  }
}

class MemoryCommentActionsState extends State<MemoryCommentActions> {
  ModalService _modalService;
  NavigationService _navigationService;
  BottomSheetService _bottomSheetService;
  UserService _userService;
  ToastService _toastService;
  ThemeService _themeService;
  LocalizationService _localizationService;
  ThemeValueParserService _themeValueParserService;

  bool _requestInProgress;
  CancelableOperation _requestOperation;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _bottomSheetService = openbookProvider.bottomSheetService;
      _navigationService = openbookProvider.navigationService;
      _modalService = openbookProvider.modalService;
      _themeService = openbookProvider.themeService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }

    List<Widget> actionItems = [
      _buildReactButton(),
    ];

    if (widget.showReplyAction &&
        _userService
            .getLoggedInUser()
            .canReplyPostComment(widget.postComment)) {
      actionItems.add(_buildReplyButton());
    }

    actionItems.addAll([
      _buildMoreButton(),
    ]);

    return Opacity(
      opacity: 0.8,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actionItems),
    );
  }

  Widget _buildMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: GestureDetector(
          onTap: _onWantsToOpenMoreActions,
          child: SizedBox(
              child: OBIcon(
            OBIcons.moreHorizontal,
            themeColor: OBIconThemeColor.secondaryText,
          ))),
    );
  }

  Widget _buildReactButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: GestureDetector(
          onTap: _reactToPostComment,
          child: SizedBox(
              child: StreamBuilder(
                  initialData: widget.postComment,
                  builder: (BuildContext context,
                      AsyncSnapshot<PostComment> snapshot) {
                    PostComment postComment = snapshot.data;

                    PostCommentReaction reaction = postComment.reaction;
                    bool hasReaction = reaction != null;

                    OBTheme activeTheme = _themeService.getActiveTheme();

                    return hasReaction
                        ? OBText(
                            reaction.getEmojiKeyword(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _themeValueParserService
                                    .parseGradient(
                                        activeTheme.primaryAccentColor)
                                    .colors[1]),
                          )
                        : OBSecondaryText(
                            _localizationService.post__action_react,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                  })),
        ));
  }

  Widget _buildReplyButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: GestureDetector(
          onTap: _replyToPostComment,
          child: SizedBox(
              child: OBSecondaryText(
            _localizationService.post__action_reply,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
  }

  void _replyToPostComment() async {
    PostComment comment = await _modalService.openExpandedReplyCommenter(
        context: context,
        post: widget.post,
        postComment: widget.postComment,
        onReplyDeleted: widget.onReplyDeleted,
        onReplyAdded: widget.onReplyAdded);
    if (comment != null) {
      await _navigationService.navigateToPostCommentReplies(
          post: widget.post,
          postComment: widget.postComment,
          onReplyAdded: widget.onReplyAdded,
          onReplyDeleted: widget.onReplyDeleted,
          context: context);
    }
  }

  void _reactToPostComment() {
    if (widget.postComment.hasReaction()) {
      _clearPostCommentReaction();
    } else {
      _bottomSheetService.showReactToPostComment(
          post: widget.post, postComment: widget.postComment, context: context);
    }
  }

  Future _clearPostCommentReaction() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);

    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostCommentReaction(
              postComment: widget.postComment,
              postCommentReaction: widget.postComment.reaction,
              post: widget.post));

      await _requestOperation.value;
      widget.postComment.clearReaction();
    } catch (error) {
      _onError(error);
    } finally {
      _requestOperation = null;
      _setRequestInProgress(false);
    }
  }

  void _onWantsToOpenMoreActions() {
    _bottomSheetService.showMoreCommentActions(
        context: context,
        post: widget.post,
        postComment: widget.postComment,
        onPostCommentDeleted: widget.onPostCommentDeleted,
        onPostCommentReported: widget.onPostCommentReported);
  }

  void _setRequestInProgress(bool clearPostReactionInProgress) {
    setState(() {
      _requestInProgress = clearPostReactionInProgress;
    });
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }
}
