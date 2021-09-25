import 'package:Siuu/models/notifications/connection_confirmed_notification.dart';
import 'package:Siuu/models/notifications/notification.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/theming/actionable_smart_text.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBConnectionConfirmedNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ConnectionConfirmedNotification connectionConfirmedNotification;
  final VoidCallback onPressed;

  const OBConnectionConfirmedNotificationTile(
      {Key key,
      @required this.notification,
      @required this.connectionConfirmedNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    var navigateToConfirmatorProfile = () {
      if (onPressed != null) onPressed();
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      openbookProvider.navigationService.navigateToUserProfile(
          user: connectionConfirmedNotification.connectionConfirmator,
          context: context);
    };
    LocalizationService _localizationService =
        OpenbookProvider.of(context).localizationService;

    return OBNotificationTileSkeleton(
      onTap: navigateToConfirmatorProfile,
      leading: OBAvatar(
        size: OBAvatarSize.small,
        avatarUrl: connectionConfirmedNotification.connectionConfirmator
            .getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToConfirmatorProfile,
        user: connectionConfirmedNotification.connectionConfirmator,
        text: TextSpan(
            text: _localizationService
                .notifications__accepted_connection_request_tile),
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created, _localizationService)),
    );
  }
}
