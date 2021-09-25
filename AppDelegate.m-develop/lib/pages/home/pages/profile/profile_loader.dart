import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/progress_indicator.dart';
import 'package:Siuu/widgets/tiles/loading_indicator_tile.dart';
import 'package:flutter/material.dart';

class ProfileLoader extends StatefulWidget {
  final int userId;
  ProfileLoader({
    @required this.userId,
  });

  @override
  _ProfileLoaderState createState() => _ProfileLoaderState();
}

class _ProfileLoaderState extends State<ProfileLoader> {
  NavigationService _navigationService;
  UserService _userService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _navigationService = openbookProvider.navigationService;
    if (_userService == null) {
      _userService = openbookProvider.userService;
      _userService
          .getUserFromUserId(widget.userId)
          .then((value) => navigate(value));
    }
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        color: Colors.white,
        child: Center(
          child: OBProgressIndicator(
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
    );
  }

  void navigate(User user) async {
    await _navigationService.navigateToUserProfile(
        user: user, context: context);
    Navigator.pop(context);
  }
}
