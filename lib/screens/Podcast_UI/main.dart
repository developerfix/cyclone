import 'package:cyclone/screens/Podcast_UI/body.dart';
import 'package:flutter/material.dart';

import 'bottom_bar.dart';

List<String> channels = [
  'teknoseyir.jpg',
  'acikbilim.jpg',
  'dnomak.jpg',
  'yalinkod.jpg',
  'unsalunlu.jpg',
  'teknolojivebilimnotlari.jpg',
  'oyungundemi.jpg',
  'mesutcevik.jpg',
  'gelecekbilimde.jpg',
  'studio71.jpg'
];

class PodcastMainUI extends StatefulWidget {
  @override
  _PodcastMainUIState createState() => _PodcastMainUIState();
}

class _PodcastMainUIState extends State<PodcastMainUI> {
  bool _searchbar = false;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    channels.shuffle();
    super.initState();
  }

  void _searchClicked() {
    setState(() {
      _searchbar = !_searchbar;
    });
  }

  Future<bool> _onBackPressed() {
    setState(() {
      _searchbar = false;
    });
    Navigator.pop(context, false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_searchbar)
          return _onBackPressed();
        else
          return true;
      },
      child: Scaffold(
        appBar: _searchbar
            ? AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: _searchClicked,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey[600],
                  ),
                ),
                title: TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                    hintText: 'Search podcast ',
                    border: InputBorder.none,
                  ),
                ))
            : AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey[600],
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: _searchClicked,
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  )
                ],
                title: Text(
                  'Podcasts',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      color: Colors.grey[700]),
                )),
        body: _searchbar
            ? Container(color: Colors.white)
            : Body(channels: channels),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
