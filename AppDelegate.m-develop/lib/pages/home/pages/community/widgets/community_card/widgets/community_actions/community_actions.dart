import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/community/widgets/community_card/widgets/community_actions/widgets/community_action_more/community_action_more.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/buttons/actions/join_community_button.dart';
import 'package:Siuu/widgets/buttons/community_button.dart';
import 'package:flutter/material.dart';

class OBMemoryActions extends StatelessWidget {
  final Memory crew;

  OBMemoryActions(this.crew);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    NavigationService navigationService = openbookProvider.navigationService;
    UserService userService = openbookProvider.userService;
    LocalizationService localizationService =
        openbookProvider.localizationService;

    User loggedInUser = userService.getLoggedInUser();

    bool isMemoryAdmin = crew?.isAdministrator(loggedInUser) ?? false;
    bool isMemoryModerator = crew?.isModerator(loggedInUser) ?? false;

    List<Widget> actions = [];

    if (isMemoryAdmin || isMemoryModerator) {
      actions.add(
          _buildManageButton(navigationService, context, localizationService));
    } else {
      actions.addAll([
        OBJoinMemoryButton(crew),
        const SizedBox(
          width: 10,
        ),
        OBMemoryActionMore(crew)
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }

  _buildManageButton(NavigationService navigationService, context,
      LocalizationService localizationService) {
    return OBMemoryButton(
        crew: crew,
        isLoading: false,
        text: localizationService.community__actions_manage_text,
        onPressed: () {
          navigationService.navigateToManageMemory(
              crew: crew, context: context);
        });
  }
}
