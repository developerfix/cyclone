import 'package:cyclone/widgets/CustomPostContainer.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(),
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
