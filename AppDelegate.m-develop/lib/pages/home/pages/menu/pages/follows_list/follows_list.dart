import 'package:Siuu/models/follows_list.dart';
import 'package:Siuu/pages/home/pages/menu/pages/follows_list/widgets/follows_list_header/follows_list_header.dart';
import 'package:Siuu/pages/home/pages/menu/pages/follows_list/widgets/follows_list_users.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_accent_text.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Siuu/services/httpie.dart';

class OBFollowsListPage extends StatefulWidget {
  final FollowsList followsList;

  OBFollowsListPage(this.followsList);

  @override
  State<OBFollowsListPage> createState() {
    return OBFollowsListPageState();
  }
}

class OBFollowsListPageState extends State<OBFollowsListPage> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;
    var modalService = openbookProvider.modalService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          trailing: GestureDetector(
            onTap: () {
              modalService.openEditFollowsList(
                  followsList: widget.followsList, context: context);
            },
            child: OBPrimaryAccentText(
                _localizationService.user__follows_list_edit),
          ),
        ),
        child: RefreshIndicator(
            key: _refreshIndicatorKey,
            child: OBPrimaryColorContainer(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),
                    OBFollowsListHeader(widget.followsList),
                    Expanded(
                      child: OBFollowsListUsers(widget.followsList),
                    ),
                  ],
                ),
              ),
            ),
            onRefresh: _refreshFollowsList));
  }

  void _bootstrap() async {
    await _refreshFollowsList();
  }

  Future<void> _refreshFollowsList() async {
    try {
      await _userService.getFollowsListWithId(widget.followsList.id);
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
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }
}
