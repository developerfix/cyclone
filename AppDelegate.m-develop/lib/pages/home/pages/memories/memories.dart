import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/place/place.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/story/controller/story_controller.dart';
import 'package:Siuu/widgets/progress_indicator.dart';
import 'package:Siuu/widgets/tiles/loading_indicator_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/pages/home/pages/memories/myMemory.dart';
import 'package:Siuu/pages/home/pages/memories/categories.dart';

import '../storyView.dart';

class Memories extends StatefulWidget {
  final String avatar;
  final UserStory userStoryList;

  const Memories({
    @required this.avatar,
    @required this.userStoryList,
  });

  @override
  State<Memories> createState() {
    return MemoriesState();
  }
}

class UserStoryData {
  String name;
  String id;
  String avtar;

  UserStoryData(this.name, this.id, this.avtar);
}

class MemoriesState extends State<Memories> {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  List<UserStoryData> user_data = new List();
  StoryController storyController;

  @override
  void initState() {
    storyController = StoryController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Memories oldWidget) {
    if (oldWidget.userStoryList != widget.userStoryList) totaluserStory();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('BUILDING STORIES NOW WITH DATA: ${widget.userStoryList.myStories}');
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final String userPic = widget.avatar;

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            SizedBox(height: height * 0.004),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(color: 0xff78849e, label: 'Moments', fontSize: 14),
                /*Row(
                  children: [
                    Image.asset('assets/images/playIcon.png'),
                    buildText(
                        color: 0xff000000, label: 'Watch all', fontSize: 14),
                  ],
                )*/
              ],
            ),
            SizedBox(height: height * 0.004),
            SizedBox(
              height: height * 0.131,
              child: Row(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        height: height * 0.0892,
                        width: width * 0.1482,
                        // height: height * 0.096,
                        // width: width * 0.160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: width * 0.004,
                          ),
                        ),
                        child: SizedBox(
                          height: height * 0.083,
                          width: width * 0.1385,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: InkWell(
                                      onTap: () {
                                        _navigateToStory();
                                      },
                                      child: Container(
                                        width: width * 0.1482,
                                        height: height * 0.0892,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // color: Colors.red,
                                            gradient: linearGradient
                                            // border: Border.all(color: Colors.red, width: 2),
                                            ),
                                        child: Center(
                                          child: Container(
                                            height: height * 0.053,
                                            width: width * 0.1085,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: userPic != null
                                                      ? NetworkImage(userPic)
                                                      : AssetImage(
                                                          "assets/images/fallbacks/avatar-fallback.jpg")),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            child: Container(),
                                          ),
                                        ),
                                      ))),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child:
                                      SvgPicture.asset('assets/svg/plus.svg')),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.007),
                      buildText(
                          color: 0xff7E7E7E,
                          label: 'Create Moment',
                          fontSize: 12)
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _myStorycoumn(widget.userStoryList, height, width),
                  Expanded(
                    child: user_data != null
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: user_data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var sameStories =
                                  getsameuserstory(user_data[index].id);
                              return InkWell(
                                onTap: () {
                                  setState(() {});
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute<Map>(
                                      builder: (context) => MyMemory(
                                        sameStories,
                                        "userStroy",
                                        storyController,
                                      ),
                                    ),
                                  )
                                      .then((value) {
                                    /*setState(() {
                                      widget.userStoryList.
                                    });*/
                                  });

                                  // _navigationService.navigateToViewStory(
                                  //   type: "userStroy",
                                  //     context: context,
                                  //     userStory: getsameuserstory(
                                  //         user_data[index].id));
                                },
                                child: buildStatusColumn(
                                  gradient: linearGradient,
                                  //   imagePath: userStoryList.stories[index].avatar!=null?userStoryList.stories[index].avatar.toString():'assets/images/icon.png',
                                  imagePath: user_data[index].avtar != null
                                      ? user_data[index].avtar
                                      : 'assets/images/icon.png',
                                  //  name:userStoryList.stories[index].username.toString()),
                                  name: user_data[index].name,
                                  storyList: sameStories,
                                ),
                              );
                              //  );
                            },
                          )
                        : Text(""),
                  )
                ],
              ),

              /*     ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    children: [
                      Container(
                        height: height * 0.0892,
                        width: width * 0.1482,
                        // height: height * 0.096,
                        // width: width * 0.160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: width * 0.004,
                          ),
                        ),
                        child: SizedBox(
                          height: height * 0.083,
                          width: width * 0.1385,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: InkWell(
                                      onTap: () {
                                        _navigationService
                                            .navigateToCreateStory(
                                                context: context);
                                      },
                                      child: Container(
                                        width: width * 0.1482,
                                        height: height * 0.0892,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // color: Colors.red,
                                            gradient: linearGradient
                                            // border: Border.all(color: Colors.red, width: 2),
                                            ),
                                        child: Center(
                                          child: Container(
                                            height: height * 0.053,
                                            width: width * 0.1085,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: userPic != null
                                                      ? NetworkImage(userPic)
                                                      : AssetImage(
                                                          "assets/images/fallbacks/avatar-fallback.jpg")),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            child: Container(),
                                          ),
                                        ),
                                      ))),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child:
                                      SvgPicture.asset('assets/svg/plus.svg')),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.007),
                      buildText(
                          color: 0xff7E7E7E, label: 'Your Moment', fontSize: 12)
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {});
                      _navigationService.navigateToViewStory(context: context);
                    },
                    child: buildStatusColumn(
                        gradient: linearGradient,
                        imagePath: 'assets/images/icon.png',
                        name: 'grandpa'),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {});
                      _navigationService.navigateToStory(context: context);
                    },
                    child: buildStatusColumn(
                        gradient: linearGradient,
                        imagePath: 'assets/images/friend1.png',
                        name: 'grandpa'),
                  ),
                ],
              ),*/
            ),
            SizedBox(height: height * 0.014),
          ],
        ));
  }

  void totaluserStory() {
    /*String userId = "";
    for (int i = 0; i < widget.userStoryList.myStories.length; i++) {
      if (userId != widget.userStoryList.myStories[i].userId) {
        if (!isUserExist(widget.userStoryList.myStories[i].userId)) {
          userId = widget.userStoryList.myStories[i].userId;
          user_data.add(new UserStoryData(
              widget.userStoryList.myStories[i].username,
              widget.userStoryList.myStories[i].userId,
              widget.userStoryList.myStories[i].avatar));
        }
      }
    }*/
    String userId = "";
    widget.userStoryList.stories.sort((a, b) => b.time.compareTo(a.time));
    for (int i = 0; i < widget.userStoryList.stories.length; i++) {
      if (userId != widget.userStoryList.stories[i].userId) {
        if (!isUserExist(widget.userStoryList.stories[i].userId)) {
          userId = widget.userStoryList.stories[i].userId;
          user_data.add(new UserStoryData(
              widget.userStoryList.stories[i].username,
              widget.userStoryList.stories[i].userId,
              widget.userStoryList.stories[i].avatar));
        }
      }
    }
  }

  bool isUserExist(String userID) {
    bool isexist = false;
    for (int i = 0; i < user_data.length; i++) {
      if (user_data[i].id == userID) {
        isexist = true;
      }
    }
    return isexist;
  }

  List<Story> getsameuserstory(String userId) {
    List<Story> userSameStory = [];
    for (int i = 0; i < widget.userStoryList.stories.length; i++) {
      if (userId == widget.userStoryList.stories[i].userId) {
        userSameStory.add(widget.userStoryList.stories[i]);
      }
    }
    for (int i = 0; i < widget.userStoryList.myStories.length; i++) {
      if (userId == widget.userStoryList.myStories[i].userId) {
        userSameStory.add(widget.userStoryList.myStories[i]);
      }
    }

    userSameStory.sort((a, b) => a.time.compareTo(b.time));
    return userSameStory;
  }

  bool isAllViewed(List<Story> stories) {
    if (stories == null) return false;
    var viewed = true;
    for (Story story in stories) {
      if (story.is_viewed == false) {
        viewed = false;
        break;
      }
    }
    return viewed;
  }

  /*void getStoryList() async {
    print("this is calll FOR STORY LIST ");

    var provider = OpenbookProvider.of(context);
    _userService = provider
        .userService; // fixme abuabkar just for testing un regiuster unser
    userStoryList = new UserStory();
    userStoryList = await _userService.getStory();
    totaluserStory();
  }*/

  Row buildStatusColumn(
      {String imagePath,
      String name,
      Gradient gradient,
      List<Story> storyList}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var isAllStoriesViewed = isAllViewed(storyList);
    return Row(
      children: [
        SizedBox(
          width: width * 0.048,
        ),
        Column(
          children: [
            Container(
              width: width * 0.1482,
              height: height * 0.0892,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.red,
                  gradient: isAllStoriesViewed ? allViewedGradient : gradient
                  // border: Border.all(color: Colors.red, width: 2),
                  ),
              child: Center(
                child: Container(
                  height: height * 0.083,
                  width: width * 0.1385,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: imagePath.startsWith('assets')
                        ? Image.asset(imagePath)
                        : CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(imagePath),
                            backgroundColor: Colors.transparent,
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.007),
            buildText(color: 0xff000000, fontSize: 12, label: name)
          ],
        ),
      ],
    );
  }

  Text buildText({String label, double fontSize, int color}) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }

  _myStorycoumn(UserStory _userStory, double height, double width) {
    if (_userStory != null) {
      if (_userStory.myStories != null && _userStory.myStories.length > 0) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {});
                Navigator.of(context, rootNavigator: true)
                    .push(
                  MaterialPageRoute<Map>(
                    builder: (context) => MyMemory(
                      getsameuserstory(
                          _userStory.myStories.first?.userId ?? ''),
                      "myStroy",
                      storyController,
                      userStoryList: widget.userStoryList,
                    ),
                  ),
                )
                    .then((Map value) {
                  if (value != null && value.containsKey('page')) {
                    if (value['page'] == 'categories') {
                      UserStory resultStory = value['story'] as UserStory;

                      try {
                        widget.userStoryList.myStories
                            ?.addAll(resultStory.myStories);
                        widget.userStoryList.onMapStories
                            ?.addAll(resultStory.onMapStories);
                      } catch (_) {}
                      setState(() {});
                      if (PlacesPage.updateMap != null) {
                        PlacesPage.updateMap();
                      }
                    }
                  }
                });

                // _navigationService.navigateToViewStory(
                //   type: "userStroy",
                //     context: context,
                //     userStory: getsameuserstory(
                //         user_data[index].id));
              },
              child: buildStatusColumn(
                gradient: linearGradient,
                imagePath: _userService.getLoggedInUser()?.profile?.avatar ??
                    'assets/images/icon.png',
                //  name:userStoryList.stories[index].username.toString()),
                name: 'Your Moment',
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Gradient allViewedGradient = LinearGradient(
    // List: [
    //   Color(purpleColor),
    //   Color(pinkColor),
    // ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    // stops: [0.5, 0.5],
    colors: [
      Colors.grey[600],
      Colors.grey[600],
    ],
  );

  Future<Widget> buildMemoryPage() async {
    return Future.microtask(() => Categories());
  }

  void _navigateToStory() async {
    /*var overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            color: Colors.black.withOpacity(0.25),
            child: Center(
              child: OBProgressIndicator(
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);*/
    var page = await buildMemoryPage();
    //overlayEntry.remove();
    var route = MaterialPageRoute<Map>(builder: (_) => page);
    Navigator.of(context, rootNavigator: true)
        .push(
      route,
    )
        .then((value) {
      if (value != null && value.containsKey('page')) {
        if (value['page'] == 'categories') {
          UserStory resultStory = value['story'] as UserStory;
          setState(() {
            try {
              widget.userStoryList.myStories?.addAll(resultStory.myStories);
              widget.userStoryList.onMapStories
                  ?.addAll(resultStory.onMapStories);
            } catch (_) {}
          });
          if (PlacesPage.updateMap != null) {
            PlacesPage.updateMap();
          }
        }
      }
    });
    isAllViewed(widget.userStoryList.stories);
    setState(() {});
  }
}
