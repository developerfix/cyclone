import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/memories/memory_comments/widgets/post_comment/widgets/memory_comment_text.dart';
import 'package:Siuu/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_actions.dart';
import 'package:Siuu/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_commenter_identifier.dart';
import 'package:Siuu/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_reactions.dart';
import 'package:Siuu/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_text.dart';
import 'package:Siuu/pages/home/pages/profile/profile_loader.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/user_preferences.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:async/async.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:Siuu/widgets/messgae/bubble.dart';

import 'widgets/memory_comment_commenter_identifier.dart';

class MemoryComment extends StatefulWidget {
  final MomentComment momentComment;
  final Story story;
  final ValueChanged<MomentComment> onMomentCommentDeleted;
  final ValueChanged<MomentComment> onMomentCommentReported;
  final bool showReplies;
  final bool showActions;

  final bool showReplyAction;
  final bool showReactions;
  final EdgeInsets padding;

  MemoryComment({
    @required this.story,
    @required this.momentComment,
    this.onMomentCommentDeleted,
    this.onMomentCommentReported,
    Key key,
    this.showReplies = true,
    this.showActions = true,
    this.showReactions = true,
    this.showReplyAction = true,
    this.padding = const EdgeInsets.only(left: 15, right: 15, top: 10),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MemoryCommentState();
  }
}

class MemoryCommentState extends State<MemoryComment> {
  NavigationService _navigationService;

  List<String> mAudioAssetRightList = new List();
  List<String> mAudioAssetLeftList = new List();
  UserPreferencesService _userPreferencesService;
  AudioCache cache = AudioCache();

  CancelableOperation _requestOperation;
  AudioPlayer mAudioPlayer = AudioPlayer(playerId: "101010");
  bool play_auduo = false;

  @override
  void initState() {
    super.initState();

    mAudioAssetRightList.add("assets/images/audio_animation_list_right_1.png");
    mAudioAssetRightList.add("assets/images/audio_animation_list_right_2.png");
    mAudioAssetRightList.add("assets/images/audio_animation_list_right_3.png");
    mAudioAssetLeftList.add("assets/images/audio_animation_list_left_1.png");
    mAudioAssetLeftList.add("assets/images/audio_animation_list_left_2.png");
    mAudioAssetLeftList.add("assets/images/audio_animation_list_right_3.png");
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
    mAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _navigationService = provider.navigationService;
    _userPreferencesService = provider.userPreferencesService;

    User commenter = widget.momentComment.commenter;

    List<Widget> commentBodyColumnItems = [
      MemoryCommentCommenterIdentifier(
        story: widget.story,
        momentComment: widget.momentComment,
        onUsernamePressed: _onPostCommenterPressed,
      ),
      const SizedBox(
        height: 5,
      ),
      // fixme Abubakar commnet body hare
      commentBody()
    ];

    /*if (widget.showReactions) {
            commentBodyColumnItems.add(
              MemoryCommentReactions(
                postComment: widget.postComment,
                post: widget.post,
              ),
            );
          }

          if (widget.showActions) {
            commentBodyColumnItems.addAll([
              MemoryCommentActions(
                post: widget.post,
                postComment: widget.postComment,
                onReplyDeleted: _onReplyDeleted,
                onReplyAdded: _onReplyAdded,
                onPostCommentReported: widget.onPostCommentReported,
                onPostCommentDeleted: widget.onPostCommentDeleted,
                showReplyAction: widget.showReplyAction,
              ),
            ]);
          }*/
    var myUserId = provider.userService.getLoggedInUser().id.toString();
    if (widget.momentComment.userId == myUserId ||
        widget.story.userId == myUserId) {
      return removableComment(
        commentBox(
          commenter: commenter,
          commentBodyColumnItems: commentBodyColumnItems,
        ),
      );
    } else {
      return commentBox(
          commenter: commenter, commentBodyColumnItems: commentBodyColumnItems);
    }
  }

  Widget removableComment(Widget child) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: child,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            widget.onMomentCommentDeleted(widget.momentComment);
          },
        ),
      ],
    );
  }

  Widget notRemovableComment(Widget child) {
    return child;
  }

  Widget commentBox({commenter, commentBodyColumnItems}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: widget.padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              OBAvatar(
                avatarUrl: commenter?.getProfileAvatar() ??
                    widget.momentComment.avatar,
                customSize: 35,
                onPressed: _onPostCommenterPressed,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: commentBodyColumnItems),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> stop(String path) async {
    int result = await mAudioPlayer.stop();
    if (result == 1) {
      play(path);
    }
  }

  Future<void> play(String path) async {
    int result = await mAudioPlayer.play(path, isLocal: false);
    if (result == 1) {
      print("getCurrentPosition:::${mAudioPlayer.onDurationChanged}");
      setState(() {
        play_auduo = true;
      });
    }
  }

  Widget commentBody() {
    print("this is type::calll");

    return MemoryCommentText(
      widget.momentComment,
      widget.story,
      onUsernamePressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileLoader(
              userId: int.parse(
                widget.momentComment.userId,
              ),
            ),
          ),
        );
      },
    );
    /* else if (type == "anim") {
      return Container(
        child:
            Lottie.asset('assets/lottie/${widget.postComment.animation}.json'),
        height: 90,
        width: 90,
      );
    } else {
      return MemoryCommentText(
        widget.postComment,
        widget.post,
        onUsernamePressed: () {
          _navigationService.navigateToUserProfile(
              user: widget.postComment.commenter, context: context);
        },
      );
    }*/
  }

  playLocal(String path) async {
    stop(path);
  }

  BubbleStyle getItemBundleStyle() {
    BubbleStyle styleSendText = BubbleStyle(
      nip: BubbleNip.rightText,
      color: Color(0xffcceaff),
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
      padding: BubbleEdges.only(top: 8, bottom: 10, left: 15, right: 10),
    );
    BubbleStyle styleSendImg = BubbleStyle(
      nip: BubbleNip.noRight,
      color: Colors.transparent,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
    );

    BubbleStyle styleReceiveText = BubbleStyle(
      nip: BubbleNip.no,
      color: Colors.blue.shade100,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(right: 50.0),
      padding: BubbleEdges.only(top: 8, bottom: 10, left: 10, right: 10),
    );

    BubbleStyle styleReceiveImg = BubbleStyle(
      nip: BubbleNip.noLeft,
      color: Colors.transparent,
      nipOffset: 5,
      nipWidth: 10,
      nipHeight: 10,
      margin: BubbleEdges.only(left: 50.0),
    );

    return styleReceiveText;
    /*  switch (mMessage.msgType) {
      case HrlMessageType.image:
        return widget.mMessage.isSend ? styleSendImg : styleReceiveImg;
        break;
      case HrlMessageType.text:
        return widget.mMessage.isSend ? styleSendText : styleReceiveText;
        break;
      case HrlMessageType.voice:
        return widget.mMessage.isSend ? styleSendText : styleReceiveText;
        break;
    }*/
  }

  /*Widget _buildPostCommentReplies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: widget.momentComment.getPostCommentReplies().length,
            itemBuilder: (context, index) {
              PostComment reply = widget.postComment.getPostCommentReplies()[0];

              return MemoryComment(
                key: Key('postCommentReply#${reply.id}'),
                padding: EdgeInsets.only(top: 15),
                postComment: reply,
                post: widget.post,
                onPostCommentDeleted: _onReplyDeleted,
              );
            }),
        _buildViewAllReplies()
      ],
    );
  }*/

  /*Widget _buildViewAllReplies() {
    if (!widget.postComment.hasReplies() ||
        (_repliesCount == _replies.length)) {
      return SizedBox();
    }

    return FlatButton(
        child: OBSecondaryText(
          'View all $_repliesCount replies',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _onWantsToViewAllReplies);
  }*/

  /*void _onWantsToViewAllReplies() {
    _navigationService.navigateToPostCommentReplies(
        post: widget.post,
        postComment: widget.postComment,
        context: context,
        onReplyDeleted: _onReplyDeleted,
        onReplyAdded: _onReplyAdded);
  }*/

  /*void _onReplyDeleted(PostComment postCommentReply) async {
    setState(() {
      _repliesCount -= 1;
      _replies.removeWhere((reply) => reply.id == postCommentReply.id);
    });
  }
*/
  /* void _onReplyAdded(PostComment postCommentReply) async {
    PostCommentsSortType sortType =
        await _userPreferencesService.getPostCommentsSortType();
    setState(() {
      if (sortType == PostCommentsSortType.dec) {
        _replies.insert(0, postCommentReply);
      } else if (_repliesCount == _replies.length) {
        _replies.add(postCommentReply);
      }
      _repliesCount += 1;
    });
  }*/

  void _onPostCommenterPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileLoader(
          userId: int.parse(
            widget.momentComment.userId,
          ),
        ),
      ),
    );
  }
}

typedef void OnWantsToSeeUserProfile(User user);
