import 'package:flutter/material.dart';

import 'CustomAppBar.dart';

class CustomScaffold extends StatefulWidget {
  final CustomAppBar appBar;
  final Widget body;
  final Color backgroundColor;

  const CustomScaffold({Key key, this.appBar, this.body, this.backgroundColor})
      : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  final double barHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(top: barHeight - 16),
              child: widget.body),
          widget.appBar.copyWith(barHeight: barHeight)

        ],
      ),
    );
  }
}
