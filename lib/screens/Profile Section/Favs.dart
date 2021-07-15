import 'package:flutter/material.dart';

class Favs extends StatefulWidget {
  @override
  _FavsState createState() => _FavsState();
}

class _FavsState extends State<Favs> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTopicContainer(
                      onTap: () {},
                      imagePath: 'assets/images/place.png',
                      text: 'Favourite Posts'),
                  buildTopicContainer(
                      onTap: () {
                        Navigator.pushNamed(context, '/favBooks');
                      },
                      imagePath: 'assets/images/app-icon.png',
                      text: 'Favourite Books'),
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildTopicContainer({String text, String imagePath, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: new Container(
        height: 200.00,
        width: 160.00,
        decoration: BoxDecoration(
          color: Color(0xfff1caa4),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.00, 3.00),
              color: Color(0xff000000).withOpacity(0.16),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(5.00),
        ),
        child: Center(
          child: new Text(
            text,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}
