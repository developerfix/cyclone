import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/actions/favorite_community_tile.dart';
import 'package:Siuu/widgets/tiles/actions/new_post_notifications_for_community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBManageMemoryPage extends StatelessWidget {
  final Memory crew;

  const OBManageMemoryPage({@required this.crew});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    NavigationService navigationService = openbookProvider.navigationService;
    ModalService modalService = openbookProvider.modalService;
    UserService userService = openbookProvider.userService;
    LocalizationService _localizationService =
        openbookProvider.localizationService;

    User loggedInUser = userService.getLoggedInUser();
    List<Widget> menuListTiles = [];

    const TextStyle listItemSubtitleStyle = TextStyle(fontSize: 14);

    if (loggedInUser.canChangeDetailsOfMemory(crew)) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.memories),
        title: OBText(
            _localizationService.trans('community__manage_details_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_details_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          modalService.openEditMemory(context: context, crew: crew);
        },
      ));
    }

    if (loggedInUser.canAddOrRemoveAdministratorsInMemory(crew)) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.crewAdministrators),
        title: OBText(
            _localizationService.trans('community__manage_admins_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_admins_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToMemoryAdministrators(
              context: context, crew: crew);
        },
      ));
    }

    if (loggedInUser.canAddOrRemoveModeratorsInMemory(crew)) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.crewModerators),
        title:
            OBText(_localizationService.trans('community__manage_mods_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_mods_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToMemoryModerators(
              context: context, crew: crew);
        },
      ));
    }

    if (loggedInUser.canBanOrUnbanUsersInMemory(crew)) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.crewBannedUsers),
        title: OBText(
            _localizationService.trans('community__manage_banned_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_banned_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToMemoryBannedUsers(
              context: context, crew: crew);
        },
      ));
    }

    if (loggedInUser.canBanOrUnbanUsersInMemory(crew)) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.crewModerators),
        title: OBText(
            _localizationService.trans('community__manage_mod_reports_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_mod_reports_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToMemoryModeratedObjects(
              context: context, crew: crew);
        },
      ));
    }

    if (loggedInUser.canCloseOrOpenPostsInMemory(crew)) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.closePost),
        title: OBText(
            _localizationService.trans('community__manage_closed_posts_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_closed_posts_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToMemoryClosedPosts(
              context: context, crew: crew);
        },
      ));
    }

    menuListTiles.add(OBNewPostNotificationsForMemoryTile(
        crew: crew,
        title: OBText(
          _localizationService.community__manage_enable_new_post_notifications,
          style: listItemSubtitleStyle,
        ),
        subtitle: OBText(
          _localizationService.community__manage_disable_new_post_notifications,
          style: listItemSubtitleStyle,
        )));

    menuListTiles.add(ListTile(
      leading: const OBIcon(OBIcons.crewInvites),
      title:
          OBText(_localizationService.trans('community__manage_invite_title')),
      subtitle: OBText(
        _localizationService.trans('community__manage_invite_desc'),
        style: listItemSubtitleStyle,
      ),
      onTap: () {
        modalService.openInviteToMemory(context: context, crew: crew);
      },
    ));

    menuListTiles.add(OBFavoriteMemoryTile(
        crew: crew,
        favoriteSubtitle: OBText(
          _localizationService.trans('community__manage_add_favourite'),
          style: listItemSubtitleStyle,
        ),
        unfavoriteSubtitle: OBText(
          _localizationService.trans('community__manage_remove_favourite'),
          style: listItemSubtitleStyle,
        )));

    if (loggedInUser.isCreatorOfMemory(crew)) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.deleteMemory),
        title: OBText(
            _localizationService.trans('community__manage_delete_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_delete_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToDeleteMemory(
              context: context, crew: crew);
        },
      ));
    } else {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.leaveMemory),
        title:
            OBText(_localizationService.trans('community__manage_leave_title')),
        subtitle: OBText(
          _localizationService.trans('community__manage_leave_desc'),
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToLeaveMemory(context: context, crew: crew);
        },
      ));
    }

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.trans('community__manage_title'),
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: menuListTiles)),
          ],
        ),
      ),
    );
  }
}
