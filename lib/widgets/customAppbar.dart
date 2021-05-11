import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget actionButton;

  CustomAppBar({this.actionButton});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: linearGradient),
      child: Column(
        children: [
          // SizedBox(
          //   height: 20,
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            height: 60,
            child: Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svg/logo.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    new Text(
                      "Cyclone",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        color: Color(0xfffff5eb),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                widget.actionButton == null
                    ? Row(
                        children: [
                          SvgPicture.asset('assets/svg/question.svg'),
                          SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset('assets/svg/notification.svg'),
                        ],
                      )
                    : widget.actionButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
