import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: width,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(),
                      CircleAvatar(
                        maxRadius: 50,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                buildText(
                    color: 0xff000000,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    text: "Freddie Mercury"),
                SizedBox(
                  height: 5,
                ),
                buildText(
                    color: 0xff5f5f5f,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    text: "+1 232 234 2342"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/svg/edit.svg'),
                        SizedBox(
                          width: 30,
                        ),
                        SvgPicture.asset('assets/svg/upload.svg')
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 20,
                ),
                buildHeadingRow(text: "Personality"),
                SizedBox(
                  height: 20,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 10,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 20,
                ),
                buildHeadingRow(text: "Personality Flaws"),
                SizedBox(
                  height: 20,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 10,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
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

  Row buildHeadingRow({String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildText(
            color: 0xff000000,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            text: text),
      ],
    );
  }

  Row buildRow({
    String text1,
    String text2,
    String text3,
  }) {
    return Row(
      children: [
        buildContainer(text: text1),
        Spacer(),
        buildContainer(text: text2),
        Spacer(),
        buildContainer(text: text3),
      ],
    );
  }

  InkWell buildContainer({String text}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/messages');
      },
      child: new Container(
        height: 43.00,
        width: 95.00,
        decoration: BoxDecoration(
          color: Color(0xfffff5eb),
          borderRadius: BorderRadius.circular(15.00),
        ),
        child: Center(
          child: buildText(
              color: 0xff000000,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              text: text),
        ),
      ),
    );
  }

  Text buildText(
      {String text, FontWeight fontWeight, double fontSize, int color}) {
    return new Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
