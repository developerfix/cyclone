import 'package:cyclone/Podcast/services/settings/mobile_settings_service.dart';
import 'package:cyclone/Podcast/ui/anytime_podcast_app.dart';
import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
    final _mobileSettingsService = Provider.of<MobileSettingsService>(context);

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
                          fontFamily: "Billabong",
                          fontWeight: FontWeight.w600,
                          // fontStyle: FontStyle.italic,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ],
                ),
                Spacer(),
                widget.actionButton == null
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AnytimePodcastApp(
                                      _mobileSettingsService)));
                        },
                        child: Icon(Icons.podcasts, color: Colors.white))
                    : widget.actionButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
