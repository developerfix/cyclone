import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/moment_comment_list.dart';
import 'package:Siuu/models/moment_reaction_list.dart';
import 'package:Siuu/models/moment_viewers.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/FixedStoryView.dart';
import 'package:Siuu/pages/home/pages/fixed_gesture_detector.dart';
import 'package:Siuu/pages/home/pages/memories/categories.dart';
import 'package:Siuu/pages/home/pages/memories/memory_comments/memory_comments_page.dart';
import 'package:Siuu/pages/home/pages/memories/memory_likers.dart';
import 'package:Siuu/pages/home/pages/memories/memory_reactions.dart';
import 'package:Siuu/pages/home/pages/profile/profile_loader.dart';
import 'package:Siuu/pages/home/pages/storyView.dart';
import 'package:Siuu/pages/home/widgets/lottieStickers.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/story/story_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:Siuu/models/StoryComment.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/letter_avatar.dart';

import 'dart:math' as math;

import 'memory_viewers/memory_viewers_page.dart';

class MyMemory extends StatefulWidget {
  final StoryController controller;
  List<Story> userStory;
  String type;
  UserStory userStoryList;

  MyMemory(this.userStory, this.type, this.controller, {this.userStoryList});

  static bool iskeybordshow = false;

  @override
  _MyMemoryState createState() => _MyMemoryState(userStory);
}

class _MyMemoryState extends State<MyMemory> {
  //final formKey1 = GlobalKey<FormState>();

  List<Story> userStory;

  _MyMemoryState(this.userStory);

  double height;
  double width;
  var keyboardVisible;
  int storyid;
  StoryItem storyItem;

  TextEditingController commentsController;

  UserService _userService;
  MomentComment _storyComments;

  bool expandViews;
  bool crewLongPress;
  bool isFollowed;
  FocusNode textFocus;
  int isone = 0;
  ValueNotifier<String> timeagooo;
  bool ismyyy;
  NavigationService _navigationService;
  ValueNotifier<String> reaction;

  @override
  void initState() {
    print("INIT STATE");
    super.initState();
    isFollowed = false;
    expandViews = false;
    crewLongPress = false;
    timeagooo = ValueNotifier("");
    reaction = ValueNotifier("");

    viewerCount = ValueNotifier(0);
    likerCount = ValueNotifier(0);
    dislikerCount = ValueNotifier(0);
    commentCount = ValueNotifier(0);

    commentsController = TextEditingController();
    textFocus = FocusNode();

    //ADDED FOR KEYBOARD CONTROL WHEN USER CLOSE KEYBOARD NEED TO UNFOCUS TEXTFIELD (IT WILL PLAY STORY)
    KeyboardVisibilityController keyboardVisibilityController =
        new KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (textFocus.hasFocus && !visible) {
        textFocus.unfocus();
      }
    });

    //ADDED FOR TEXTFIELD FOCUS WHEN USER TYPING WE WILL STOP STORY
    textFocus.addListener(() {
      if (textFocus.hasFocus) {
        print("PAUSE");
        widget.controller.pause();
      } else {
        print("PLAY");
        widget.controller.play("");
      }
    });
    hideWidgetsOnStop();
    _opacity = ValueNotifier(1.0);
  }

  ValueNotifier<double> _opacity;

  void hideWidgetsOnStop() {
    widget.controller.playbackNotifier.stream.listen((value) {
      if (value == PlaybackState.pause) {
        hideWidgets();
      } else {
        showWidgets();
      }
    });
  }

  hideWidgets() {
    _opacity.value = 0.0;
  }

  showWidgets() {
    _opacity.value = 1.0;
  }

  Widget profilePic(String link, String name) {
    print('My  link is $link and name: $name');
    if (link == null) {
      return OBLetterAvatar(
          borderRadius: 20,
          size: OBAvatarSize.small,
          color: Colors.red,
          letter: name != null ? name[0] : '');
    } else {
      return OBAvatar(
        borderWidth: 3,
        avatarUrl: link,
        //avatarFile: _avatarFile,
        size: OBAvatarSize.small,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("checkkkk state::");

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    var openbookProvider = OpenbookProvider.of(context);
    var _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;

    _navigationService = openbookProvider.navigationService;

    return FixedDismissible(
      behavior: HitTestBehavior.translucent,
      direction: DismissDirection.vertical,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      onVerticalDragStart: (details) => FixedStoryView.onVerticalDragStart(
          controller: widget.controller, details: details),
      onVerticalDragCancel: () =>
          FixedStoryView.onVerticalDragCancel(controller: widget.controller),
      onVerticalDragEnd: (details) => FixedStoryView.onVerticalDragEnd(
          controller: widget.controller, details: details),
      onVerticalDragUpdate: (details) => FixedStoryView.onVerticalDragUpdate(
          controller: widget.controller, details: details),
      resizeDuration: Duration(milliseconds: 150),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: MoreStories(
                  currentStory: (String id) {
                    print('CHANGING TIME AGO: ${timeagooo.value}');
                    timeagooo.value = timeAgoeachStory(id);
                    storyid = int.parse(id);
                    setCount(storyid);
                    _userService.putMomentView(storyId: storyid);
                    final story = userStory
                        .firstWhere((element) => element.id == storyid);
                    story.is_viewed = true;
                    viewerCount.value = story.views_count;
                    likerCount.value = story.likes_count;
                    dislikerCount.value = story.dislikes_count;
                    commentCount.value = story.comment_count;
                  },
                  currentStoryItem: (StoryItem storyItemVal) {
                    storyItem = storyItemVal;
                  },
                  storyController: widget.controller,
                  textFocus: textFocus,
                  userStory: userStory,
                  width: width,
                  height: height,
                ),
                // child: MoreStories(userSameStory, controller),
                // child: MoreStories(widget.controller, textFocus, userStory),
              ),
              Positioned.fill(
                child: ValueListenableBuilder(
                  valueListenable: _opacity,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: rightSide(),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _opacity,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.029),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    XGestureDetector(
                                      onTap: (_) async {
                                        widget.controller.pause();
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ProfileLoader(
                                                userId: int.parse(
                                                    userStory[0].userId)),
                                          ),
                                        );
                                        widget.controller.play("");
                                        /*_navigationService.navigateToUserProfile(
                                            user: User(
                                              id: int.parse(userStory[0].userId),
                                            ),
                                            context: context);*/
                                      },
                                      child: Container(
                                        child: widget.type == 'myStroy'
                                            ? profilePic(
                                                _userService
                                                    .getLoggedInUser()
                                                    ?.profile
                                                    ?.avatar,
                                                _userService
                                                    .getLoggedInUser()
                                                    ?.profile
                                                    ?.name)
                                            : profilePic(
                                                userStory[0].avatar,
                                                userStory[0].name,
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.024),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildText(
                                            text:
                                                '${userStory[0].name} @${userStory[0].username}',
                                            color: Colors.white),
                                        SizedBox(width: width * 0.024),
                                        ValueListenableBuilder(
                                          valueListenable: timeagooo,
                                          builder: (context, _timeAgo, child) {
                                            print('TIME AGO GELDI?? $_timeAgo');
                                            return buildText(
                                              text: _timeAgo,
                                              color: Color(0xffffffff)
                                                  .withOpacity(0.70),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  widget.type == "myStroy"
                                      ? Container(
                                          color: Colors.transparent,
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            child: Container(
                                                height: height * 0.051,
                                                width: width * 0.085,
                                                //  child: Image.asset("assets/images/addmystory.png",fit: BoxFit.fitWidth)
                                                child: Image(
                                                    image: AssetImage(
                                                        "assets/images/addmystory.png"))),
                                            onTap: () async {
                                              widget.controller.pause();
                                              var route =
                                                  MaterialPageRoute<Map>(
                                                      builder: (_) =>
                                                          Categories());
                                              await Navigator.of(context)
                                                  .push(
                                                route,
                                              )
                                                  .then((Map value) {
                                                if (value != null &&
                                                    value.containsKey('page')) {
                                                  if (value['page'] ==
                                                      'categories') {
                                                    UserStory resultStory =
                                                        value['story']
                                                            as UserStory;
                                                    Navigator.of(context).pop(
                                                      {
                                                        'page': 'categories',
                                                        'story': resultStory,
                                                      },
                                                    );
                                                  }
                                                }
                                              });
                                              widget.controller.play('');
                                            },
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(width: width * 0.024),
                                  buildText(text: "     ", color: Colors.white),
                                  SizedBox(width: width * 0.024),
                                  buildText(
                                    text: "     ",
                                    color: Color(0xffffffff).withOpacity(0.70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              if (widget.type == 'myStroy')
                                IconButton(
                                  iconSize: 28,
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: () async {
                                    widget.controller.pause();
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Container(
                                            width: width / 100 * 75,
                                            child: Card(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Are you sure to delete this moment?',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                      Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                              return Colors
                                                                  .grey[700];
                                                            },
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                      Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                              return Colors.red;
                                                            },
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _userService
                                                              .deleteStory(
                                                                  storyId:
                                                                      storyid);
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                          try {
                                                            widget.userStoryList
                                                                .myStories
                                                                .removeWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        storyid);
                                                            widget.userStoryList
                                                                .onMapStories
                                                                .removeWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        storyid);
                                                          } catch (_) {}
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    setState(() {});
                                    widget.controller.play('');
                                  },
                                ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              /* Align(
                alignment: Alignment.center,
                child: buildTextField(height, width),
              ),*/
              /*_StoryComment != null
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        height: height * 0.258,
                        width: width,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Column(
                                  children: comentlist(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),*/
              expandViews
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        height: height * 0.658,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    /*setState(() {
                                        expandViews = true;
                                      });*/
                                  },
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Icon(Icons.arrow_back_ios,
                                        color: Colors.white),
                                  ),
                                ),
                                buildView(),
                                buildView(),
                                buildView(),
                                buildView(),
                                buildView(),
                                buildView(),
                              ],
                            ),
                            // Spacer(),
                          ),
                        ),
                      ),
                    )
                  : crewLongPress
                      ? Container()
                      : Positioned(
                          bottom: 0,
                          child: false
                              ? Container(
                                  height: height * 0.131,
                                  width: width,
                                  color: Colors.black.withOpacity(0.5),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: InkWell(
                                            onTap: () {
                                              /*setState(() {
                                                  expandViews = true;
                                                });*/
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle: 180 * math.pi / 360,
                                                  child: Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.white),
                                                ),
                                                /*   buildText(
                                    color: Colors.white,
                                    text: '20 Views')*/
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: buildTextField(height, width),
                                        ),
                                        SizedBox(width: width * 0.072),
                                        SizedBox(width: width * 0.024),
                                        SizedBox(width: width * 0.024),
                                        SizedBox(width: width * 0.024),
                                        SizedBox(width: width * 0.024),
                                        SizedBox(width: width * 0.024),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    // LottieStickers(width: width),
                                    /*Container(
                                      height: height * 0.131,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      /*child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/storyCamera.svg'),
                                          buildTextField(height, width),
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              if (commentsController
                                                      .text.isEmpty ||
                                                  commentsController.text
                                                          .trim()
                                                          .length <
                                                      1) {
                                                _toastService.error(
                                                    message: "Comment is Empty",
                                                    context: context);
                                                return;
                                              } else {
                                                _userService
                                                    .uploadStoryComments(
                                                        text: commentsController
                                                            .text,
                                                        storyId: storyid);
                                              }
                                            },
                                            child: SvgPicture.asset(
                                                'assets/svg/storyMsgSendIcon.svg'),
                                          )
                                        ],
                                      ),*/
                                    ),*/
                                  ],
                                ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  ValueNotifier<int> viewerCount;
  ValueNotifier<int> likerCount;
  ValueNotifier<int> dislikerCount;
  ValueNotifier<int> commentCount;

  setCount(int storyId) {
    getLikeCount(storyId);
    //getCommentCounts(storyId);
    //getViewers(storyId);
  }

  Future<void> getLikeCount(int storyId) async {
    //var _likerCount = 0;
    //var _dislikerCount = 0;
    MomentReactionList reactionList =
        await _userService.getReactionsForMoment(storyId);
    //momentReactionList = reactionList;
    for (var reactionn in reactionList.reactions) {
      if (reactionn.userId == _userService.getLoggedInUser().id.toString())
        reaction.value = reactionn.reaction;
      if (reactionn.reaction == 'like') {
        //_likerCount += 1;
      } else {
        //_dislikerCount += 1;
      }
    }
    if (reactionList.reactions.any((element) =>
            element.userId == _userService.getLoggedInUser().id.toString()) ==
        false) {
      reaction.value = '';
    }
    //likerCount.value = _likerCount;
    //dislikerCount.value = _dislikerCount;
  }

/*
  Future<void> getCommentCounts(int storyId) async {
    MomentCommentList comments =
        await _userService.getCommentsForMoment(storyId);
    commentCount.value = comments.commentCount ?? 0;
  }

  Future<void> getViewers(int storyId) async {
    MomentViewers viewers =
        await _userService.getMomentViewers(storyId: storyId);
    viewerCount.value = viewers.viewers?.length ?? 0;
  }
*/
  Widget rightSide() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.fromLTRB(
          0,
          0,
          0,
          height * 0.131 + height / 100 * 1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            likeButton(),
            SizedBox(
              height: 5,
            ),
            dislikeButton(),
            SizedBox(
              height: 5,
            ),
            commentsButton(),
            SizedBox(
              height: 5,
            ),
            if (widget.type == "myStroy") viewersButton(),
          ],
        ),
      ),
    );
  }

  Widget likeButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.type == 'myStroy') {
              widget.controller.pause();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MemoryReactionsPage(
                    story: widget.userStory.firstWhere(
                        (element) => element.id == storyid,
                        orElse: null),
                    reactionType: 'like',
                  ),
                ),
              );
              widget.controller.play("");
              return;
            }
            _userService.reactToMoment(
                storyid: storyid,
                reaction: 'like',
                avatar: _userService.getLoggedInUser().profile.avatar);
            if (reaction.value == 'like') {
              reaction.value = '';
              likerCount.value -= 1;
              widget.userStory
                  .firstWhere((element) => element.id == storyid, orElse: null)
                  .likes_count -= 1;
            } else {
              if (reaction.value == 'dislike') {
                dislikerCount.value -= 1;

                widget.userStory
                    .firstWhere((element) => element.id == storyid,
                        orElse: null)
                    .dislikes_count -= 1;
              }
              reaction.value = 'like';
              likerCount.value += 1;
              widget.userStory
                  .firstWhere((element) => element.id == storyid, orElse: null)
                  .likes_count += 1;
            }
          },
          child: ValueListenableBuilder(
            valueListenable: reaction,
            builder: (context, reactionValue, child) {
              if (reactionValue == 'like')
                return Container(
                  //padding: EdgeInsets.only(bottom: height / 100 * 1),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        linearGradient.createShader(bounds),
                    child: Icon(
                      Icons.thumb_up_alt,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                );
              else
                return Container(
                  //padding: EdgeInsets.only(bottom: height / 100 * 1),
                  child: Icon(
                    Icons.thumb_up_alt,
                    size: 28,
                    color: Colors.white,
                  ),
                );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: likerCount,
          builder: (context, value, child) => Text(
            '${value == null ? '0' : value}',
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget dislikeButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.type == 'myStroy') {
              widget.controller.pause();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MemoryReactionsPage(
                    story: widget.userStory.firstWhere(
                        (element) => element.id == storyid,
                        orElse: null),
                    reactionType: 'dislike',
                  ),
                ),
              );
              widget.controller.play("");
              return;
            }
            _userService.reactToMoment(
                storyid: storyid,
                reaction: 'dislike',
                avatar: _userService.getLoggedInUser().profile.avatar);
            if (reaction.value == 'dislike') {
              reaction.value = '';
              dislikerCount.value -= 1;
              widget.userStory
                  .firstWhere((element) => element.id == storyid, orElse: null)
                  .dislikes_count -= 1;
            } else {
              if (reaction.value == 'like') {
                likerCount.value -= 1;

                widget.userStory
                    .firstWhere((element) => element.id == storyid,
                        orElse: null)
                    .likes_count -= 1;
              }
              reaction.value = 'dislike';
              dislikerCount.value += 1;
              widget.userStory
                  .firstWhere((element) => element.id == storyid, orElse: null)
                  .dislikes_count += 1;
            }
          },
          child: ValueListenableBuilder(
            valueListenable: reaction,
            builder: (context, reactionValue, child) {
              if (reactionValue == 'dislike')
                return Container(
                  //padding: EdgeInsets.only(bottom: height / 100 * 1),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        linearGradient.createShader(bounds),
                    child: Icon(
                      Icons.thumb_down_alt,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                );
              else
                return Container(
                  //padding: EdgeInsets.only(bottom: height / 100 * 1),
                  child: Icon(
                    Icons.thumb_down_alt,
                    size: 28,
                    color: Colors.white,
                  ),
                );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: dislikerCount,
          builder: (context, value, child) => Text(
            '${value == null ? '0' : value}',
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget commentsButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            widget.controller.pause();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MemoryCommentPage(
                  story: widget.userStory.firstWhere(
                      (element) => element.id == storyid,
                      orElse: null),
                  storyItem: storyItem,
                ),
              ),
            );
            widget.controller.play("");
          },
          child: Container(
            //padding: EdgeInsets.only(bottom: height / 100 * 1),
            child: SvgPicture.asset(
              'assets/svg/comments.svg',
              height: 28,
              color: Colors.white,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: commentCount,
          builder: (context, value, child) => Text(
            '${value == null ? '0' : value}',
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget viewersButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            widget.controller.pause();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MemoryViewersPage(
                  story: widget.userStory.firstWhere(
                      (element) => element.id == storyid,
                      orElse: null),
                ),
              ),
            );
            widget.controller.play("");
          },
          child: Container(
            //padding: EdgeInsets.only(bottom: height / 100 * 1),
            child: Icon(
              Icons.remove_red_eye,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: viewerCount,
          builder: (context, value, child) => Text(
            '${value == null ? '0' : value}',
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String timeAgoeachStory(String id) {
    String timeAgoo = "";
    for (int i = 0; i < userStory.length; i++) {
      if (id == userStory[i].id.toString()) {
        print('STORY Time is: ${userStory[i].time}');
        timeAgoo = getRelativeCreated(userStory[i].time);
        print("timeeee agoooo::$timeAgoo");
      }
    }

    if (isone > 1) {
      //setState(() {});
    }
    isone++;

    return timeAgoo;
  }

  String getRelativeCreated(DateTime time) {
    return timeago.format(time ?? DateTime(2000));
  }

  Padding buildView() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              SizedBox(width: width * 0.024),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade400.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      buildText(text: 'John doe', color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              /*setState(
                () {
                  //
                },
              );*/
            },
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 34.0,
            ),
          )
        ],
      ),
    );
  }

  /*Padding buildCommentsRow(MomentComment comment) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
          ),
          SizedBox(width: width * 0.048),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade400.withOpacity(0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(text: comment.name, color: Colors.white),
                  buildText(text: comment.text, color: Colors.grey.shade400)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }*/

  Container buildTextField(height, width) {
    return Container(
      height: height * 0.064,
      width: width * 0.709,
      decoration: BoxDecoration(
        border: Border.all(
          width: width * 0.002,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        //ADDED PART FOR FOCUSNODE
        focusNode: textFocus,
        //ADDED FOCUS NODE
        controller: commentsController,
        // key: formKey1,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          hintText: 'Comment...',
          hintStyle: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }

  Text buildText({@required String text, @required Color color}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 13,
        color: color,
      ),
    );
  }

  /*Future<StoryComment> getStoryComment(int id) async {
    _storyComments = await _userService.getStoryComments(storyId: storyid);

    if (_storyComments.data.length > 0) return _storyComments;
  }*/

  /*List<Widget> comentlist() {
    //getStoryComment(storyid);
    List<Widget> list = new List();

    if (_storyComments != null) {
      print("ifffffffffffffffff ");
      for (int i = 0; i < _storyComments.data.length; i++) {
        list.add(buildCommentsRow(_storyComments.data[i]));
      }
    } else {
      print("elseeeeeeeeeeeee");
    }
    return list;
  }*/
}

/*class MyMemory extends StatefulWidget {
  final Widget crew = null;
  List<Story> _userStory;
  static bool iskeybordshow = false;

  MyMemory({@required Widget crew, @required List<Story> userStory}) {
    _userStory = userStory;
  }

  @override
  _MyMemoryState createState() => _MyMemoryState(_userStory);
}

class _MyMemoryState extends State<MyMemory>{
  final formKey = GlobalKey<FormState>();
  List<Story> userSameStory;

  double height;
  double width;
  var keyboardVisible;
  TextEditingController commentsController = TextEditingController();
  ToastService _toastService;
  UserService _userService;
  KeyboardVisibilityNotification _keyboardVisibility =
  new KeyboardVisibilityNotification();
  Duration _duration;
  static bool iskeybordshow = false;

  _MyMemoryState(this.userSameStory);

  bool expandViews;
  bool crewLongPress;
  final StoryController controller = StoryController();
  bool isFollowed;

  @override
  void initState() {
    super.initState();
    isFollowed = false;
    expandViews = false;
    crewLongPress = false;
    _duration = new Duration(seconds: 3);
    _keyboardVisibility.addNewListener(onChange: (bool visible) {
      MyMemory.iskeybordshow = visible;
      if (visible) {
        controller.pause();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    print("checkkkk state::");

    var openbookProvider = OpenbookProvider.of(context);
    _toastService = openbookProvider.toastService;
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    keyboardVisible = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    return
      SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      crewLongPress = true;
                    });
                  },
                  onLongPressEnd: (details) {
                    setState(() {
                      crewLongPress = false;
                    });
                  },
                 // child: MoreStories(userSameStory, controller),
                  child: MoreStories(userSameStory, controller),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.029),
                    */ /*  FlutterSlider(
                      disabled: true,
                      handler: FlutterSliderHandler(
                        child: Container(),
                      ),
                      trackBar: FlutterSliderTrackBar(),
                      values: [40],
                      hatchMark: FlutterSliderHatchMark(disabled: true),
                      handlerHeight: 0,
                      handlerWidth: 0,
                      max: 100,
                      min: 0,
                    ),*/ /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: userSameStory[0].avatar != null
                                        ? NetworkImage(userSameStory[0].avatar)
                                        : AssetImage(
                                        'assets/images/photo1.png'),
                                  ),
                                  shape: BoxShape.circle),
                              height: height * 0.051,
                              width: width * 0.085,
                            ),
                            SizedBox(width: width * 0.024),
                            buildText(
                                text: '' + userSameStory[0].username.toString(),
                                color: Colors.white),
                            SizedBox(width: width * 0.024),
                            buildText(
                              text: '' +
                                  getRelativeCreated(userSameStory[0].time),
                              color: Color(0xffffffff).withOpacity(0.70),
                            ),
                          ],
                        ),
                        IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              //controller.pause();
                              Navigator.pop(context);
                            })
                      ],
                    )
                  ],
                ),
              ),
              crewLongPress
                  ? Container()
                  : Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.transparent,
                  height: height * 0.258,
                  width: width,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          buildCommentsRow(comment: 'beautiful Picture'),
                          buildCommentsRow(
                              comment:
                              'Lorem Ipsum is simply dummy text '),
                          buildCommentsRow(
                              comment:
                              'It is a long established fact that a reader will\nbe distracted by the readable content '),
                          buildCommentsRow(comment: 'beautiful Picture'),
                          buildCommentsRow(
                              comment:
                              'ly five centuries, but also the leap'),
                          buildCommentsRow(comment: 'beautiful Picture'),
                          buildCommentsRow(comment: 'beautiful Picture'),
                          buildCommentsRow(comment: 'beautiful Picture'),
                          buildCommentsRow(comment: 'beautiful Picture'),
                          buildCommentsRow(comment: 'beautiful Picture'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              expandViews
                  ? Positioned(
                bottom: 0,
                child: Container(
                  height: height * 0.658,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                expandViews = true;
                              });
                            },
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                            ),
                          ),
                          buildView(id: 1),
                          buildView(id: 2),
                          buildView(),
                          buildView(),
                          buildView(id: 5),
                          buildView(),
                          buildView(),
                          buildView(),
                          buildView(),
                        ],
                      ),
                      // Spacer(),
                    ),
                  ),
                ),
              )
                  : crewLongPress
                  ? Container()
                  : Positioned(
                bottom: 0,
                child: keyboardVisible == 0
                    ? Container(
                  height: height * 0.131,
                  width: width,
                  color: Colors.black.withOpacity(0.5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                expandViews = true;
                              });
                            },
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Transform.rotate(
                                  angle: 180 * math.pi / 360,
                                  child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white),
                                ),
                                buildText(
                                    color: Colors.white,
                                    text: '20 Views')
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              10, 0, 10, 0),
                          child: buildTextField(height, width),
                        ),
                        SizedBox(width: width * 0.072),
                        SvgPicture.asset('assets/svg/like.svg',
                            height: height * 0.058),
                        SizedBox(width: width * 0.024),
                        SvgPicture.asset(
                            'assets/svg/dislike.svg',
                            height: height * 0.058),
                        SizedBox(width: width * 0.024),
                        SvgPicture.asset(
                            'assets/svg/heartReact.svg',
                            height: height * 0.058),
                        SizedBox(width: width * 0.024),
                        SvgPicture.asset(
                            'assets/svg/brokenHeart.svg',
                            height: height * 0.058),
                        SizedBox(width: width * 0.024),
                        SvgPicture.asset('assets/svg/haha.svg',
                            height: height * 0.058),
                        SizedBox(width: width * 0.024),
                        SvgPicture.asset('assets/svg/shock.svg',
                            height: height * 0.058),
                        SizedBox(width: width * 0.024),
                        SvgPicture.asset('assets/svg/smirk.svg',
                            height: height * 0.058),
                        SizedBox(width: width * 0.024),
                      ],
                    ),
                  ),
                )
                    : Column(
                  children: [
                    // LottieStickers(width: width),
                    Container(
                      height: height * 0.131,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                              'assets/svg/storyCamera.svg'),
                          buildTextField(height, width),
                          InkWell(
                            onTap: () {
                              if (commentsController
                                  .text.isEmpty ||
                                  commentsController
                                      .text.length <
                                      1) {
                                _toastService.error(
                                    message: "Comment is Empty",
                                    context: context);
                                return;
                              } else {
                                _userService
                                    .uploadStoryComments(
                                    text:
                                    "my first commnet",
                                    story_id: 101);
                              }
                            },
                            child: SvgPicture.asset(
                                'assets/svg/storyMsgSendIcon.svg'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getRelativeCreated(DateTime time) {
    return timeago.format(time);
  }

  Padding buildView({int id}) {
    final double height = MediaQuery
        .of(context)
        .size
        .height;
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/friend1.png'),
              ),
              SizedBox(width: width * 0.024),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: linearGradient
                  // color: Colors.grey.shade400.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      buildText(text: 'John doe', color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          id == 2 || id == 5
              ? SvgPicture.asset(
            'assets/svg/comment.svg',
            height: height * 0.049,
            color: Colors.white,
          )
              : InkWell(
            onTap: () {
              setState(
                    () {
                  if (id == 1) {
                    isFollowed ? isFollowed = false : isFollowed = true;
                  }
                },
              );
            },
            child: id == 1
                ? isFollowed
                ? ShaderMask(
              shaderCallback: (Rect bounds) {
                return linearGradient.createShader(bounds);
              },
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 34.0,
              ),
            )
                : Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 34.0,
            )
                : Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 34.0,
            ),
          )
        ],
      ),
    );
  }

  Padding buildCommentsRow({String comment}) {
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/friend2.png'),
          ),
          SizedBox(width: width * 0.048),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade400.withOpacity(0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(text: 'John doe', color: Colors.white),
                  buildText(text: comment, color: Colors.grey.shade400)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildTextField(double height, double width) {
    return Container(
      height: height * 0.064,
      width: width * 0.709,
      decoration: BoxDecoration(
        border: Border.all(
          width: width * 0.002,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: commentsController,
        key: formKey,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          hintText: 'Comment...',
          hintStyle: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }

  Text buildText({String text, Color color}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 13,
        color: color,
      ),
    );
  }


}*/
