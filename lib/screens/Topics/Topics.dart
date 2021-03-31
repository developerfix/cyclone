import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';

class Topics extends StatefulWidget {
  @override
  _TopicsState createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              new Text(
                "Tree of Life",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 40,
                  color: Color(0xff000000),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTopicContainer(
                      imagePath: 'assets/images/healthPicture.png',
                      text: 'Health'),
                  buildTopicContainer(
                      imagePath: 'assets/images/ethicsPicture.png',
                      text: 'Health'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTopicContainer(
                      imagePath: 'assets/images/motivationPicture.png',
                      text: 'Health'),
                  buildTopicContainer(
                      imagePath: 'assets/images/spiritualityPicture.png',
                      text: 'Health'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTopicContainer(
                      imagePath: 'assets/images/healthPicture.png',
                      text: 'Health'),
                  buildTopicContainer(
                      imagePath: 'assets/images/healthPicture.png',
                      text: 'Health'),
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

  InkWell buildTopicContainer({String text, String imagePath}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/topicDetails');
      },
      child: new Container(
        height: 231.00,
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
        child: Column(
          children: [
            new Text(
              text,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 30,
                color: Color(0xffffffff),
              ),
            ),
            Opacity(opacity: 0.7, child: Image.asset(imagePath))
          ],
        ),
      ),
    );
  }
}
