import 'package:auto_size_text/auto_size_text.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';

class TopicDetails extends StatefulWidget {
  @override
  _TopicDetailsState createState() => _TopicDetailsState();
}

class _TopicDetailsState extends State<TopicDetails> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                new Text(
                  "Motivation",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                    color: Color(0xff707070),
                  ),
                ),
                new AutoSizeText(
                  "Motivation is the word derived from the word ’motive’ which means needs, desires, wants or drives within the individuals. It is the process of stimulating people to actions to accomplish the goals. In the work goal context the psychological factors stimulating the people’s behavior.",
                  // maxFontSize: 20,
                  // maxLines: 18,
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    // fontSize: 20,
                    color: Color(0xff707070),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
