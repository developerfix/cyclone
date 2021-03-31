import 'package:cyclone/screens/HomeScreen.dart';
import 'package:cyclone/screens/Profile%20Section/profile.dart';
import 'package:cyclone/screens/Topics/Topics.dart';
import 'package:cyclone/screens/customNewsfeed/customNewsfeed.dart';
import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    Widget child;
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

    return Scaffold(
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

  // Text buildText(String title) {
  //   return Text(
  //     title,
  //     textAlign: TextAlign.center,
  //     style: TextStyle(
  //       fontFamily: "Montserrat",
  //     ),
  //   );
  // }
}
