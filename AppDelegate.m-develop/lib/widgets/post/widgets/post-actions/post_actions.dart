import 'package:Siuu/custom/InstantShareDialog.dart';
import 'package:Siuu/custom/customPostContainer.dart';
import 'package:Siuu/custom/reactionPostContainer.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/avatars/logged_in_user_avatar.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Siuu/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/services/user.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:Siuu/pages/home/pages/menu/pages/followers.dart';

class OBPostActions extends StatefulWidget {
  final Post _post;
  final VoidCallback onWantsToCommentPost;

  OBPostActions(this._post, {this.onWantsToCommentPost});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OBPostActionsState(_post,
        onWantsToCommentPost: onWantsToCommentPost);
  }
}

class OBPostActionsState extends State<OBPostActions> {
  final Post _post;
  final VoidCallback onWantsToCommentPost;

  OBPostActionsState(this._post, {this.onWantsToCommentPost});

  ModalService _modalService;
  ToastService _toastService;
  var navigationService;
  UserService _userService;

  String shareType = "Public";
  TextEditingController shareTextcontrller = new TextEditingController();

  LocalizationService _localizationService;
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    List<Widget> postActions = [
      //Expanded(child: OBPostActionReact(_post)),
    ];
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    bool commentsEnabled = _post.areCommentsEnabled ?? true;
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    navigationService = openbookProvider.navigationService;

    _modalService = openbookProvider.modalService;
    _toastService = openbookProvider.toastService;

    _localizationService = openbookProvider.localizationService;
    bool canDisableOrEnableCommentsForPost = false;

    if (!commentsEnabled) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      canDisableOrEnableCommentsForPost = openbookProvider.userService
          .getLoggedInUser()
          .canDisableOrEnableCommentsForPost(_post);
    }

    if (commentsEnabled || canDisableOrEnableCommentsForPost) {
      postActions.addAll([
        GestureDetector(
          onTap: () {
            _sharePostBottomSheet(context, 300, openbookProvider);
            /*      showDialog(
              context: context,
              builder: (context) {
                return SharePostModal(post: _post);
              },
            );*/
            Future _onWantsToEditPost() async {
              try {
                await _modalService.openEditPost(context: context, post: _post);
                // _dismiss();
              } catch (error) {
                _onError(error, context);
              }
            }
          },
          child: SvgPicture.asset('assets/svg/share.svg'),
        ),
        Row(
          children: [
            Row(
              children: [
                OBPostActionComment(
                  _post,
                  onWantsToCommentPost: onWantsToCommentPost,
                ),
              ],
            ),
            SizedBox(
              width: width * 0.072,
            ),
            // fixme abubakar reaction for post
            Row(
              children: [ReactinPostContainer(_post)],
            ),
          ],
        )
        /* GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return InstantShareDialog(_post);
              },
            );
          },
          child: SvgPicture.asset('assets/svg/share.svg'),
        ),
        const SizedBox(
          width: 20.0,
        ),
        OBPostActionComment(
          _post,
          onWantsToCommentPost: onWantsToCommentPost,
        ),
        ReactinPostContainer(_post),*/
      ]);
    }

    return Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: postActions,
            ),
          ],
        ));
  }

  void _sharePostBottomSheet(context, double hight, openbookProvider) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(20),
            height: hight,
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            OBLoggedInUserAvatar(
                              size: OBAvatarSize.extraSmall,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          bottom: 5.0,
                                          top: 10),
                                      child: Text(
                                        _userService.getLoggedInUser().username,
                                        style: TextStyle(fontSize: 20),
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    sharePostType(context);
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          bottom: 20.0),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.black87,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                            child: Row(
                                          children: [
                                            Text(shareType,
                                                style: TextStyle(fontSize: 14)),
                                            Icon(Icons.arrow_drop_down)
                                          ],
                                        )),
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: shareTextcontrller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Say something about this....'),
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        if (shareType == "Except") {
                          shareType = "";
                          int i = 0;
                         exceptUserID.forEach((element) {
                           if(i==0){
                             shareType = shareType+element.toString();
                           }
                           else{
                             shareType = shareType+","+element.toString();
                           }
                           i++;

                         });
                        }

                        print("creator id::${_post.creator.id}");

                        _toastService.info(
                            message: "Post Share", context: _context);

                        _userService.share_post(
                            post_id: _post.id.toString(),
                            post_type: "shared",
                            created_by_user_id: _post.creator.id.toString(),
                            share_type:
                                shareTextcontrller.text.trim().isNotEmpty
                                    ? "quote"
                                    : "instant",
                            share_with: shareType,
                            text_attached:
                                shareTextcontrller.text.trim().isNotEmpty
                                    ? shareTextcontrller.text.trim()
                                    : "");
                        Navigator.pop(context);

                        ///  print("finlyy get ::${exceptUserID}");
                      },
                      child: Container(
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("Share now"),
                        ),
                      ),
                    ))
              ],
            ),
          );
        });
  }

  void _onError(error, BuildContext context) async {
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

  void sharePostType(BuildContext _context) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text("Alert Dialog"),
            content: dialogbody(context),
          );
        });
    /*  showDialog(
      context: _context,
      builder: (context) {
        // return SharePostModal(post: _post);
        return dialogbody(_context);
      },
    );*/
  }

  Widget dialogbody(BuildContext _context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(_context);
              setState(() {
                shareType = "Public";
              });
            },
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.public),
                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: shareTypeText(
                              text: "public",
                              color: Colors.black87,
                              size: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: shareTypeText(
                              text: "Share post With public",
                              color: Colors.black87,
                              size: 12,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              print("clickkkkk");
              Navigator.pop(_context);

              setState(() {
                shareType = "Followers";
              });
            },
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 22,
                      width: 22,
                      child: Image.asset("assets/images/follwers.png"),
                    ),                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: shareTypeText(
                              text: "Followers",
                              color: Colors.black87,
                              size: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: shareTypeText(
                              text: "your followers on siuu",
                              color: Colors.black87,
                              size: 12,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(_context);

              setState(() {
                shareType = "Except";
              });
              exceptUserID = new List();

              navigationService.navigateToFollowersPage(
                  context: _context, isSahre: true);
            },
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 20,
                      width: 20,
                      child: Image.asset("assets/images/exceptfollwers.png"),
                    ),                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: shareTypeText(
                              text: "Followers except..",
                              color: Colors.black87,
                              size: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: shareTypeText(
                              text: "Dont show to some Followers",
                              color: Colors.black87,
                              size: 12,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shareTypeText(
      {@required String text,
      @required Color color,
      @required double size,
      @required FontWeight fontWeight}) {
    return Text(
      "$text",
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        decoration: TextDecoration.none,
      ),
    );
  }
}
