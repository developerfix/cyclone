import 'package:cyclone/screens/Podcast_UI/for_you.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final List<String> channels;
  Body({this.channels});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            child: GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(4),
              crossAxisCount: 4,
              children: widget.channels
                  .map(
                    (channel) => Card(
                      child: Image.asset(
                        'assets/images/podcast_imags/$channel',
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          ForYouPanel(),
        ],
      ),
    );
  }
}
