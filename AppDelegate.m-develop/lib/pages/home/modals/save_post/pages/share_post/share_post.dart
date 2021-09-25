import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/new_post_data_uploader.dart';
import 'package:Siuu/widgets/progress_indicator.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBSharePostPage extends StatefulWidget {
  final OBNewPostData createPostData;

  const OBSharePostPage({Key key, @required this.createPostData})
      : super(key: key);

  @override
  OBSharePostPageState createState() {
    return OBSharePostPageState();
  }
}

class OBSharePostPageState extends State<OBSharePostPage> {
  bool _loggedInUserRefreshInProgress;
  bool _needsBootstrap;
  UserService _userService;
  NavigationService _navigationService;
  LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _loggedInUserRefreshInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _navigationService = openbookProvider.navigationService;
      //_bootstrap();
      _needsBootstrap = false;
    }

    User loggedInUser = _userService.getLoggedInUser();

    return Scaffold(
        appBar: _buildNavigationBar(),
        //backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height - 20,
          child: StreamBuilder(
            initialData: loggedInUser,
            stream: loggedInUser.updateSubject,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              User latestUser = snapshot.data;

              if (_loggedInUserRefreshInProgress)
                return const Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: const OBProgressIndicator(),
                  ),
                );

              const TextStyle shareToTilesSubtitleStyle =
                  TextStyle(fontSize: 14, color: Colors.black);

              List<Widget> shareToTiles = [
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.circles, color: Colors.black),
                  title: OBText(
                    _localizationService.trans('post__my_circles'),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  subtitle: OBText(
                    _localizationService.trans('post__my_circles_desc'),
                    style: shareToTilesSubtitleStyle,
                  ),
                  onTap: _onWantsToSharePostToCircles,
                )
              ];

              /* if (latestUser.isMemberOfCommunities != null &&
                  latestUser.isMemberOfCommunities) {
                shareToTiles.add(ListTile(
                  leading: const OBIcon(OBIcons.memories),
                  title: OBText(_localizationService
                      .trans('post__share_community_title')),
                  subtitle: OBText(
                    _localizationService.trans('post__share_community_desc'),
                    style: shareToTilesSubtitleStyle,
                  ),
                  onTap: _onWantsToSharePostToCommunity,
                ));
             // }*/

              return Column(
                children: <Widget>[
                  Expanded(
                      child: ListView(
                          padding: EdgeInsets.zero, children: shareToTiles)),
                ],
              );
            },
          ),
        )));
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.trans('post__share_to'),
    );
  }

  void _bootstrap() {
    _refreshLoggedInUser();
  }

  Future<void> _refreshLoggedInUser() async {
    User refreshedUser = await _userService.refreshUser();
    if (refreshedUser.isMemberOfCommunities) {
      // Only possibility
      _onWantsToSharePostToCircles();
    }
  }

  void _onWantsToSharePostToCircles() async {
    OBNewPostData createPostData =
        await _navigationService.navigateToSharePostWithCircles(
            context: context, createPostData: widget.createPostData);
    if (createPostData != null) Navigator.pop(context, createPostData);
  }

  void _onWantsToSharePostToCommunity() async {
    OBNewPostData createPostData =
        await _navigationService.navigateToSharePostWithMemory(
            context: context, createPostData: widget.createPostData);
    if (createPostData != null) Navigator.pop(context, createPostData);
  }
}
