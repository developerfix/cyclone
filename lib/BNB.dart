import 'package:cyclone/book_view_models/app_provider.dart';
import 'package:cyclone/customNewsfeed/views/customNewsFeedHome.dart';
import 'package:cyclone/screens/HomeScreen.dart';
import 'package:cyclone/screens/NewsApi/tabs/search_screen.dart';
import 'package:cyclone/screens/Profile%20Section/profile.dart';
import 'package:cyclone/screens/book_views/BookSection/Books.dart';
import 'package:cyclone/services/auth.dart';
import 'package:cyclone/theme/theme_config.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
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
        child = CustomNewsFeedHome();
        break;
      case 3:
        child = Books();
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
                        'Settings',
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 15.0,
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
                    // buildDrawerTextWidget('Notifications'),
                    InkWell(
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'Cyclone',
                            applicationVersion: 'v1.0',
                            applicationIcon: SvgPicture.asset(
                              'assets/svg/logo.svg',
                              width: 52.0,
                              height: 52.0,
                            ),
                            children: <Widget>[
                              Text('\u00a9 2020-2021 Hamza.Z'),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Cyclone.gmail.com',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.purple),
                                ),
                              ),
                            ],
                          );
                        },
                        child: buildDrawerTextWidget('About')),

                    _buildThemeSwitch(),

                    buildDrawerTextWidget('Privacy'),
                    buildDrawerTextWidget('Security'),
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
                  child: Text(
                    'LOG OUT',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15.0,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        scaffold: Scaffold(
          appBar: _index == 0 || _index == 1
              ? CustomAppBar()
              : _index == 2
                  ? PreferredSize(child: Container(), preferredSize: Size.zero)
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
                              _innerDrawerKey.currentState
                                  .toggle(direction: InnerDrawerDirection.end);
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
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch() {
    return SwitchListTile(
      title: Text(
        Provider.of<AppProvider>(context).theme == ThemeConfig.lightTheme
            ? 'Dark mode'
            : 'Light Mode',
      ),
      value: Provider.of<AppProvider>(context).theme == ThemeConfig.lightTheme
          ? false
          : true,
      onChanged: (v) {
        if (v) {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.darkTheme, 'dark');
        } else {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.lightTheme, 'light');
        }
      },
    );
  }

  Text buildDrawerTextWidget(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 16.0,
        // color: Colors.black,
        height: 1.6,
      ),
    );
  }
}
