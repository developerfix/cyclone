import 'package:Siuu/models/circle.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/bottom_sheet.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConnectToUserTile extends StatefulWidget {
  final User user;
  final BuildContext parentContext;
  final VoidCallback onWillShowModalBottomSheet;

  const OBConnectToUserTile(this.user, this.parentContext,
      {Key key, this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBConnectToUserTileState createState() {
    return OBConnectToUserTileState();
  }
}

class OBConnectToUserTileState extends State<OBConnectToUserTile> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  BottomSheetService _bottomSheetService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;
    _bottomSheetService = openbookProvider.bottomSheetService;

    String userName = widget.user.getProfileName();

    return ListTile(
        title: OBText(_localizationService.user__connect_to_user_connect_with_username(userName)),
        leading: const OBIcon(OBIcons.connect),
        onTap: _displayAddConnectionToCirclesBottomSheet);
  }

  void _displayAddConnectionToCirclesBottomSheet() {
    if (widget.onWillShowModalBottomSheet != null)
      widget.onWillShowModalBottomSheet();

    _bottomSheetService.showConnectionsCirclesPicker(
        context: context,
        title: _localizationService.trans('user__connect_to_user_add_connection'),
        actionLabel: _localizationService.trans('user__connect_to_user_done'),
        onPickedCircles: _onWantsToAddConnectionToCircles);
  }

  Future _onWantsToAddConnectionToCircles(List<Circle> circles) async {
    await _connectUserInCircles(circles);
  }

  Future _connectUserInCircles(List<Circle> circles) async {
    try {
      bool userWasFollowing = widget.user.isFollowing;
      await _userService.connectWithUserWithUsername(widget.user.username,
          circles: circles);
      if (!userWasFollowing && widget.user.isFollowing) {
        widget.user.incrementFollowersCount();
      }
      _toastService.success(
          message: _localizationService.trans('user__connect_to_user_request_sent'), context: widget.parentContext);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: _localizationService.trans('error__unknown_error'), context: context);
      throw error;
    }
  }
}
