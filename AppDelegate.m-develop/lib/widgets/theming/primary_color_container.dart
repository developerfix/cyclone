import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:flutter/material.dart';

class OBPrimaryColorContainer extends StatelessWidget {
  final Widget child;
  final BoxDecoration decoration;
  final MainAxisSize mainAxisSize;

  const OBPrimaryColorContainer(
      {Key key,
      this.child,
      this.decoration,
      this.mainAxisSize = MainAxisSize.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          Widget container = DecoratedBox(
            decoration: BoxDecoration(
                color: themeValueParserService.parseColor(theme.primaryColor),
                borderRadius: decoration?.borderRadius),
            child: child,
          );

          if (mainAxisSize == MainAxisSize.min) {
            return container;
          }

          return Column(
            mainAxisSize: mainAxisSize,
            children: <Widget>[
              /*SizedBox(
                height: height * 0.087,
              ),*/
              Expanded(child: container)
            ],
          );
        });
  }
}
