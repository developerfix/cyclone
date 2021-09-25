import 'package:Siuu/models/theme.dart';
import 'package:Siuu/pages/home/pages/menu/menu.dart';
import 'package:Siuu/pages/home/pages/search/search.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A navigation bar that uses the current theme colours
class OBThemedNavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Widget leading;
  final String title;
  final Widget trailing;
  final String previousPageTitle;
  final Widget middle;

  OBThemedNavigationBar({
    this.leading,
    this.previousPageTitle,
    this.title,
    this.trailing,
    this.middle,
  });

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;

        Color actionsForegroundColor = themeValueParserService
            .parseGradient(theme.primaryAccentColor)
            .colors[1];

        return CupertinoTheme(
          data: CupertinoThemeData(
            primaryColor: actionsForegroundColor != null
                ? actionsForegroundColor
                : Colors.black,
          ),
          child: CupertinoNavigationBar(
            border: null,
            middle: middle ??
                (title != null
                    ? OBText(
                        title,
                      )
                    : const SizedBox()),
            transitionBetweenRoutes: false,
            backgroundColor:
                themeValueParserService.parseColor(theme.primaryColor),
            trailing: trailing,
            leading: leading,
          ),
        );
      },
    );
  }

  /// True if the navigation bar's background color has no transparency.
  @override
  bool get fullObstruction => true;

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
