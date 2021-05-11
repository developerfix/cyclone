import 'package:cyclone/screens/HomeScreen.dart';
import 'package:cyclone/screens/Profile%20Section/profile.dart';
import 'package:cyclone/screens/Topics/Topics.dart';
import 'package:cyclone/screens/customNewsfeed/customNewsfeed.dart';
import 'package:cyclone/services/auth.dart';
import 'package:cyclone/utils/res.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey();
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  final AuthService _auth = AuthService();

  Widget child;

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    switch (_index) {
      case 0:
        child = HomeScreen();
        break;
      case 1:
        child = Topics();
        break;
      case 2:
        child = CustomNewsfeed();
        break;
      case 3:
        child = Profile();
        break;
    }

    return SafeArea(
      child: InnerDrawer(
          tapScaffoldEnabled: true,
          key: _innerDrawerKey,
          // onTapClose: true, // default false

          //When setting the vertical offset, be sure to use only top or bottom
          offset: IDOffset.only(left: 0.5),
          // scale: IDOffset.horizontal(1), // set the offset in both directions

          proportionalChildArea: true, // default true

          //when a pointer that is in contact with the screen and moves to the right or left
          onDragUpdate: (double val, InnerDrawerDirection direction) {
            // return values between 1 and 0
            print(val);
            // check if the swipe is to the right or to the left
            print(direction == InnerDrawerDirection.start);
          },
          innerDrawerCallback: (a) =>
              print(a), // return  true (open) or false (close)
          rightChild: Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  // color: Colors.green,
                  height: 60,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Freddie Mercury',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Divider(
                          height: 0,
                          color: Colors.black38,
                          thickness: 0.5,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildDrawerTextWidget('Notifications'),
                      buildDrawerTextWidget('About'),
                      buildDrawerTextWidget('Privacy'),
                      buildDrawerTextWidget('Security'),
                      buildDrawerTextWidget('Theme'),
                      buildDrawerTextWidget('Help'),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                      onTap: () {
                        _auth.signOut();
                      },
                      child: buildDrawerTextWidget('LOG OUT')),
                ),
              ],
            ),
          ),
          scaffold: Scaffold(
            appBar: _index == 0 || _index == 1
                ? CustomAppBar()
                : _index == 2
                    ? CustomAppBar(
                        actionButton: Icon(Icons.add, color: Colors.white),
                      )
                    : CustomAppBar(
                        actionButton: InkWell(
                          onTap: () {
                            _innerDrawerKey.currentState.toggle(
                                // direction is optional
                                // if not set, the last direction will be used
                                //InnerDrawerDirection.start OR InnerDrawerDirection.end
                                direction: InnerDrawerDirection.end);
                          },
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ),
            body: SizedBox.expand(child: child),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              // selectedItemColor: Color(twine),
              // selectedLabelStyle: TextStyle(
              //   fontFamily: "Montserrat",
              //   fontSize: 12,
              //   color: Color(twine),
              // ),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              onTap: (newIndex) => setState(() => _index = newIndex),
              currentIndex: _index,
              items: [
                buildBottomNavigationBarItem(
                  iconPath: "assets/svg/homeScreenIcon.svg",
                  index: 0,
                ),
                buildBottomNavigationBarItem(
                  iconPath: "assets/svg/learningIcon.svg",
                  index: 1,
                ),
                buildBottomNavigationBarItem(
                  iconPath: "assets/svg/customNewsfeed.svg",
                  index: 2,
                ),
                buildBottomNavigationBarItem(
                  iconPath: "assets/svg/profileIcon.svg",
                  index: 3,
                ),
              ],
            ),
          )),
    );
  }

  Text buildDrawerTextWidget(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 15.0,
        color: Colors.black,
        height: 1.6,
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      {String iconPath, int index}) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            iconPath,
            color: _index == index ? Color(twine) : null,
          ),
        ),
        label: '');
  }
}
