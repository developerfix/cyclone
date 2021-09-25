import 'package:Siuu/models/badge.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/user_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../provider.dart';

class OBUserTile extends StatelessWidget {
  final User user;
  final OnUserTilePressed onUserTilePressed;
  final OnUserTileDeleted onUserTileDeleted;
  final bool showFollowing;
  final Widget trailing;

  const OBUserTile(this.user,
      {Key key,
      this.onUserTilePressed,
      this.onUserTileDeleted,
      this.showFollowing = false,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    LocalizationService _localizationService =
        openbookProvider.localizationService;
    Widget tile = ListTile(
      onTap: () {
        //fixme abubakar handeling of recent search is pending
        _init(user);
        if (onUserTilePressed != null) onUserTilePressed(user);
      },
      leading: OBAvatar(
        username: user.username,
        size: OBAvatarSize.medium,
        avatarUrl: user.getProfileAvatar(),
      ),
      trailing: trailing,
      title: Row(children: <Widget>[
        OBText(
          user.username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _getUserBadge(user)
      ]),
      subtitle: Row(
        children: [
          OBSecondaryText(user.getProfileName()),
          showFollowing && user.isFollowing != null && user.isFollowing
              ? OBSecondaryText(
                  _localizationService.trans('user__tile_following'))
              : const SizedBox()
        ],
      ),
    );

    if (onUserTileDeleted != null) {
      tile = Slidable(
        actionPane: new SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: tile,
        secondaryActions: <Widget>[
          new IconSlideAction(
            caption: _localizationService.trans('user__tile_delete'),
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              onUserTileDeleted(user);
            },
          ),
        ],
      );
    }
    return tile;
  }

  Widget _getUserBadge(User creator) {
    if (creator.hasProfileBadges()) {
      Badge badge = creator.getProfileBadges()[0];
      return OBUserBadge(badge: badge, size: OBUserBadgeSize.small);
    }
    return const SizedBox();
  }

  // fixme abubakar put list

  Future<bool> putObjectList(String key, List<Object> list) async {
    SharedPreferences _prefs;
    _prefs = await SharedPreferences.getInstance();
    if (_prefs == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _prefs.setStringList(key, _dataList);
  }

  List<Map> getObjectList(String key, SharedPreferences _prefs) {
    if (_prefs == null) return null;
    List<String> dataLis = _prefs.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  Future _init(User user) async {
    SharedPreferences _prefs;
    _prefs = await SharedPreferences.getInstance();
    List<Map> saveuser = getObjectList("search", _prefs);

    if (saveuser == null) {
      List<User> userlist = new List();
      userlist.add(user);
      putObjectList("search", userlist);
    }

    // print("chkouttt:L:"+saveuser.length.toString());
    check_save_user(user, saveuser);
  }

  void check_save_user(User user1, List<Map> saveuser1) {
    bool issave = false;
    UserFactory userFactory = new UserFactory();
    List<User> userlist = new List();
    for (int i = 0; i < saveuser1.length; i++) {
      if (user1.id == saveuser1[i]["id"]) {
        issave = true;
      } else {
        userlist.add(userFactory.makeFromJson(saveuser1[i]));
      }
    }
    if (!issave) {
      print("chkouttt:issave:");

      userlist.add(user1);
      save_limt_chk(userlist);
    }
  }

  void save_limt_chk(List<User> userlist1) {
    if (userlist1.length > 11) {
      userlist1.removeAt(11);
    }
    putObjectList("search", userlist1);
  }
}

typedef void OnUserTilePressed(User user);
typedef void OnUserTileDeleted(User user);
