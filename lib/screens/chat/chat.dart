import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool messageSeen = false;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: PreferredSize(
      //   child: Container(
      //     height: 110,
      //     decoration: BoxDecoration(gradient: linearGradient),
      //     child: Column(
      //       children: [
      //         Container(
      //           height: 50,
      //           // color: Colors.red,
      //         ),
      //         Row(
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.only(left: 10),
      //               child: Icon(Icons.arrow_back_ios, color: Colors.white),
      //             ),
      //             Spacer(),
      //             Padding(
      //               padding: const EdgeInsets.only(right: 10),
      //               child: Container(
      //                 height: 44.00,
      //                 width: 296.00,
      //                 decoration: BoxDecoration(
      //                   color: Color(0xfffff5eb),
      //                   borderRadius: BorderRadius.circular(30.00),
      //                 ),
      //                 child: TextFormField(
      //                   cursorColor: Color(twine),
      //                   decoration: InputDecoration(
      //                     contentPadding: EdgeInsets.all(10),
      //                     border: InputBorder.none,
      //                     suffixIcon: Icon(
      //                       Icons.search,
      //                       color: Color(0xffb7b7b7),
      //                     ),
      //                     hintText: "Search…",
      //                     hintStyle: TextStyle(
      //                       fontFamily: "Monteserrat",
      //                       fontSize: 15,
      //                       color: Color(0xffb7b7b7),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Spacer(),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      //   preferredSize: Size.fromHeight(110),
      // ),
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: height * 0.04),
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Color(0xffCCCCCC),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              buildSizedBoxImages('mike'),
                              buildSizedBoxImages('mike'),
                              buildSizedBoxImages('mike'),
                              buildSizedBoxImages('mike'),
                              buildSizedBoxImages('mike'),
                              Container(
                                height: height * 0.079,
                                width: width * 0.131,
                                child: Center(
                                  child: Text(
                                    "10",
                                    style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      fontSize: 15,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xffFF566B),
                                    shape: BoxShape.circle),
                              ),
                            ],
                          ),
                          Spacer()
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 20, 30),
                    child: Column(
                      children: [
                        buildColumn(),
                        buildColumn(),
                        buildColumn(),
                        buildColumn(),
                        buildColumn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(bottom: 0, child: buildContainer(width)),
          ],
        ),
      ),
    );
  }

  SizedBox buildSizedBoxImages(String image) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.079,
      width: width * 0.131,
      child: Image.asset('assets/images/$image.png'),
    );
  }

  Column buildColumn() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildTimeText(),
        Row(
          children: [
            // Image.asset('assets/images/person1.png'),
            SizedBox(width: width * 0.024),
            InkWell(
              onTap: () {
                setState(() {
                  if (messageSeen) {
                    // print('false');
                    messageSeen = false;
                  } else
                    // print('true');

                    messageSeen = true;
                });
              },
              child: messageSeen
                  ? Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildOpponentMessageContainer(),
                        SizedBox(height: height * 0.007),
                        Row(
                          children: [
                            SizedBox(width: width * 0.024),
                            Text(
                              'Julian',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Segoe UI",
                                fontSize: 11,
                                color: Color(0xff6a6a6a),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : buildOpponentMessageContainer(),
            )
          ],
        ),
        buildTimeText(),
        SizedBox(height: height * 0.014),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: height * 0.042,
              width: width * 0.454,
              decoration: BoxDecoration(
                color: Color(0xffaaa5a5),
                borderRadius: BorderRadius.circular(15.00),
              ),
              child: Center(child: buildMessageText()),
            ),
          ],
        ),
        SizedBox(height: height * 0.014),
      ],
    );
  }

  Container buildOpponentMessageContainer() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.042,
      width: width * 0.274,
      decoration: BoxDecoration(
        gradient: linearGradient,
        borderRadius: BorderRadius.circular(15.00),
      ),
      child: Center(
        child: buildMessageText(),
      ),
    );
  }

  Text buildMessageText() {
    return Text(
      "Lorem ipsum",
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 15,
        color: Color(0xffffffff),
      ),
    );
  }

  Text buildTimeText() {
    return Text(
      "LUN.,18:49",
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: FontWeight.w300,
        fontSize: 14,
        color: Color(0xff5b055e),
      ),
    );
  }

  Container buildContainer(double width) {
    return Container(
        width: width,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.00, 4.00),
              color: Color(0xff455b63).withOpacity(0.08),
              blurRadius: 16,
            ),
          ],
          borderRadius: BorderRadius.circular(12.00),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Row(children: [
            SvgPicture.asset('assets/svg/backIcon.svg'),
            SizedBox(width: width * 0.015),
            SvgPicture.asset('assets/svg/faceIcon.svg'),
            SizedBox(width: width * 0.024),
            Expanded(
              child: Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something',
                    hintStyle: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      color: Color(0xff63697b),
                    ),
                  ),
                ),
              ),
            ),
            SvgPicture.asset('assets/svg/sendIcon.svg'),
          ]),
        ));
  }

  Text buildText(
      {String text, double fontSize, FontWeight fontWeight, Color color}) {
    return new Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
