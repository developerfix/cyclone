import 'dart:async';

import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/users_list.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/buttons/actions/follow_button.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:Siuu/services/toast.dart';


class OBFollowersPage extends StatefulWidget {
  bool isShare;

  OBFollowersPage(this.isShare);

  @override
  State<OBFollowersPage> createState() {
    return OBFollowersPageState(isShare);
  }
}

List<int> exceptUserID = new List();


class OBFollowersPageState extends State<OBFollowersPage> {
  bool isShare = false;

  OBFollowersPageState(this.isShare);

  UserService _userService;
  NavigationService _navigationService;
  LocalizationService _localizationService;

  OBHttpListController _httpListController;
  bool _needsBootstrap;
  ToastService _toastService;


  @override
  void initState() {
    super.initState();
    _httpListController = OBHttpListController();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);

    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return Scaffold(
      floatingActionButton:  isShare?FloatingActionButton(
        onPressed: () {
          if(exceptUserID.length==0){
            _toastService.error(message: "Kindly select except User", context: context);
          }
          else{
            Navigator.pop(context);

          }
        },
        child: const Icon(Icons.share),
        backgroundColor: Colors.red,
      ):Text(""),
      body:       OBCupertinoPageScaffold(

        navigationBar: OBThemedNavigationBar(
          title: _localizationService.user__followers_title,
        ),
        child: OBPrimaryColorContainer(
          child: OBHttpList<User>(
            controller: _httpListController,
            listItemBuilder: _buildFollowerListItem,
            searchResultListItemBuilder: _buildFollowerListItem,
            listRefresher: _refreshFollowers,
            listOnScrollLoader: _loadMoreFollowers,
            listSearcher: _searchFollowers,
            resourceSingularName: _localizationService.user__follower_singular,
            resourcePluralName: _localizationService.user__follower_plural,
          ),
        ),
      ),
    );


  }

  Widget _buildFollowerListItem(BuildContext context, User user) {
    return OBUserTile(user,
        onUserTilePressed: _onFollowerListItemPressed,
        trailing: userData(user));
  }

  Widget userData(User user) {
    if (isShare) {
      return RoundCheckBox(
        onTap: (selected) {
          addDateInList(user);
        },
        size: 26,
        animationDuration: Duration(microseconds: 100),
        uncheckedColor: Colors.white,
        checkedWidget: Icon(Icons.clear),
        checkedColor: Colors.red,
      );
    } else {
      return OBFollowButton(
        user,
        size: OBButtonSize.small,
        unfollowButtonType: OBButtonType.highlight,
      );
    }
  }
  void addDateInList(User user){


    if(exceptUserID.contains(user.id)){
      exceptUserID.remove(user.id);
    }
    else{
      if(exceptUserID.length<5){
    exceptUserID.add(user.id);}
      else{
        print("limt full");
      }
    }

    print("this is userid::${exceptUserID}");


  }

  void _onFollowerListItemPressed(User follower) {
    if (isShare) {
    } else {
      _navigationService.navigateToUserProfile(
          user: follower, context: context);
    }
  }

  Future<List<User>> _refreshFollowers() async {
    UsersList followers = await _userService.getFollowers();
    return followers.users;
  }

  Future<List<User>> _loadMoreFollowers(List<User> followersList) async {
    var lastFollower = followersList.last;
    var lastFollowerId = lastFollower.id;
    var moreFollowers = (await _userService.getFollowers(
      maxId: lastFollowerId,
      count: 20,
    ))
        .users;
    return moreFollowers;
  }

  Future<List<User>> _searchFollowers(String query) async {
    UsersList results = await _userService.searchFollowers(query: query);

    return results.users;
  }
}
