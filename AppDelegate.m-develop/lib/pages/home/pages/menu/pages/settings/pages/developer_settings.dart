import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/actions/clear_application_cache_tile.dart';
import 'package:Siuu/widgets/tiles/actions/clear_application_preferences_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBDeveloperSettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    LocalizationService _localizationService =
        OpenbookProvider.of(context).localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(
          title: _localizationService.drawer__developer_settings),
      child: OBPrimaryColorContainer(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            OBClearApplicationCacheTile(),
          ],
        ),
      ),
    );
  }
}
