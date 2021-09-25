import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_inline_action_more_button.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:Siuu/widgets/buttons/actions/block_button.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/actions/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OBProfileInlineActions extends StatelessWidget {
  final User user;
  final VoidCallback onUserProfileUpdated;
  final ValueChanged<Memory> onExcludedMemoryRemoved;
  final ValueChanged<List<Memory>> onExcludedCommunitiesAdded;

  const OBProfileInlineActions(this.user,
      {@required this.onUserProfileUpdated,
      this.onExcludedMemoryRemoved,
      this.onExcludedCommunitiesAdded});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var navigationService = openbookProvider.navigationService;
    LocalizationService localizationService =
        openbookProvider.localizationService;

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        bool isLoggedInUser = userService.isLoggedInUser(user);

        List<Widget> actions = [];

        if (isLoggedInUser) {
          actions.add(Padding(
            // The margin compensates for the height of the (missing) OBProfileActionMore
            // Fixes cut-off Edit profile button, and level out layout distances
            padding: EdgeInsets.only(top: 6.5, bottom: 6.5),
            child: _buildManageButton(
                navigationService, localizationService, context),
          ));
        } else {
          bool isBlocked = user.isBlocked ?? false;
          if (isBlocked) {
            actions.add(OBBlockButton(user));
          } else {
            actions.add(
              OBFollowButton(
                user,
                unfollowButtonType: OBButtonType.success,
              ),
            );
          }

          actions.addAll([
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                goToConverstation(null, ChatUser.fromGeneralUser(user));
              },
              child: SvgPicture.asset('assets/svg/comments.svg'),
            ),
            OBProfileInlineActionsMoreButton(user)
          ]);
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: actions,
        );
      },
    );
  }

  _buildManageButton(NavigationService navigationService,
      LocalizationService localizationService, context) {
    return OBButton(
        child: Text(
          localizationService.user__manage,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          navigationService.navigateToManageProfile(
              user: user,
              context: context,
              onUserProfileUpdated: onUserProfileUpdated,
              onExcludedCommunitiesAdded: onExcludedCommunitiesAdded,
              onExcludedMemoryRemoved: onExcludedMemoryRemoved);
        });
  }
}
