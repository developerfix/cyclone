import 'package:cyclone/widgets/CustomPostContainer.dart';
import 'package:flutter/material.dart';

class CustomNewsfeed extends StatefulWidget {
  @override
  _CustomNewsfeedState createState() => _CustomNewsfeedState();
}

class _CustomNewsfeedState extends State<CustomNewsfeed> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PostContainer(
                isCustomNewsfeedContainer: true,
                category: "Article",
                contentPicturePath: 'assets/images/article.png',
                publisherPicturePath: "assets/images/health.png",
                title: 'HEALTH',
              ),
              PostContainer(
                isCustomNewsfeedContainer: true,
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
