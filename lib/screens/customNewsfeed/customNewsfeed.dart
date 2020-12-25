import 'package:cyclone/utils/res.dart';
import 'package:cyclone/widgets/CustomPostContainer.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNewsfeed extends StatefulWidget {
  @override
  _CustomNewsfeedState createState() => _CustomNewsfeedState();
}

class _CustomNewsfeedState extends State<CustomNewsfeed> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(gradient: linearGradient),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
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
                    Icon(Icons.add, color: Colors.white)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PostContainer(
                category: "Article",
                contentPicturePath: 'assets/images/article.png',
                publisherPicturePath: "assets/images/health.png",
                title: 'HEALTH',
              ),
              PostContainer(
                category: "Blog",
                contentPicturePath: 'assets/images/blog.png',
                publisherPicturePath: "assets/images/football.png",
                title: 'FOOTBALL',
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
}
