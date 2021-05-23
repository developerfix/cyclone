import 'package:cyclone/screens/HomeScreen.dart';
import 'package:cyclone/screens/NewsApi/screens/tabs/search_screen.dart';
import 'package:cyclone/screens/Profile%20Section/profile.dart';
import 'package:cyclone/screens/book_views/home/home.dart';
import 'package:cyclone/screens/customNewsfeed/customNewsfeed.dart';
import 'package:cyclone/services/auth.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  final AuthService _auth = AuthService();

  Widget child;

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    switch (_index) {
      case 0:
        child = HomeScreen();
        break;
      case 1:
        child = SearchScreen();
        break;
      case 2:
        child = CustomNewsfeed();
        break;
      case 3:
        child = Home();
        break;
      case 4:
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
                    : _index == 3
                        ? CustomAppBar(
                            actionButton: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/explore');
                              },
                              child: Text(
                                "Explore",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  height: 1.6,
                                ),
                              ),
                            ),
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
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(EvaIcons.homeOutline),
                  activeIcon: Icon(EvaIcons.home),
                ),
                BottomNavigationBarItem(
                  label: "Search",
                  icon: Icon(EvaIcons.searchOutline),
                  activeIcon: Icon(EvaIcons.search),
                ),
                BottomNavigationBarItem(
                  label: "Add Topics",
                  icon: Icon(EvaIcons.plus),
                  activeIcon: Icon(EvaIcons.plusSquare),
                ),
                BottomNavigationBarItem(
                  label: "Read",
                  icon: Icon(EvaIcons.bookOpenOutline),
                  activeIcon: Icon(EvaIcons.bookOpen),
                ),
                BottomNavigationBarItem(
                  label: "Account",
                  // title: Padding(
                  //     padding: EdgeInsets.only(top: 5.0),
                  //     child: Text("Search",
                  //         style: TextStyle(fontWeight: FontWeight.w600))),
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
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

  // BottomNavigationBarItem buildBottomNavigationBarItem(
  //     {String iconPath, int index}) {
  //   return BottomNavigationBarItem(
  //       icon: Padding(
  //         padding: EdgeInsets.only(bottom: 5),
  //         child: SvgPicture.asset(
  //           iconPath,
  //           color: _index == index ? Color(twine) : null,
  //         ),
  //       ),
  //       label: '');
}
