import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';

class OBConfirmAddMemoryAdministrator<T> extends StatefulWidget {
  final User user;
  final Memory crew;

  const OBConfirmAddMemoryAdministrator(
      {Key key, @required this.user, @required this.crew})
      : super(key: key);

  @override
  OBConfirmAddMemoryAdministratorState createState() {
    return OBConfirmAddMemoryAdministratorState();
  }
}

class OBConfirmAddMemoryAdministratorState
    extends State<OBConfirmAddMemoryAdministrator> {
  bool _confirmationInProgress;
  UserService _userService;
  LocalizationService _localizationService;
  ToastService _toastService;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _confirmationInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.user.username;

    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }

    String adminDescriptionText =
        _localizationService.trans('community__admin_desc');
    String adminConfirmationText =
        _localizationService.community__admin_add_confirmation(username);

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
            title: _localizationService.trans('community__confirmation_title')),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OBIcon(
                      OBIcons.crewAdministrators,
                      themeColor: OBIconThemeColor.primaryAccent,
                      size: OBIconSize.extraLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OBText(
                      adminConfirmationText,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    OBText(
                      adminDescriptionText,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      type: OBButtonType.highlight,
                      child: Text(_localizationService.trans('community__no')),
                      onPressed: _onCancel,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      child: Text(_localizationService.trans('community__yes')),
                      onPressed: _onConfirm,
                      isLoading: _confirmationInProgress,
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  void _onConfirm() async {
    _setConfirmationInProgress(true);
    try {
      await _userService.addMemoryAdministrator(
          crew: widget.crew, user: widget.user);
      Navigator.of(context).pop(true);
    } catch (error) {
      _onError(error);
    } finally {
      _setConfirmationInProgress(false);
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
      _toastService.error(
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  void _onCancel() {
    Navigator.of(context).pop(false);
  }

  void _setConfirmationInProgress(confirmationInProgress) {
    setState(() {
      _confirmationInProgress = confirmationInProgress;
    });
  }
}