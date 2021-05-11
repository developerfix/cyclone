import 'package:flutter/material.dart';
import 'package:fradio/fradio.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  int groupValue_1 = 0;
  int groupValue_2 = 0;
  int groupValue_3 = 0;
  int groupValue_4 = 0;
  int groupValue_5 = 0;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/BNB');
                },
                child: Container(
                  height: 30,
                  width: 30,
                  color: Colors.greenAccent,
                ),
              ),
              question(
                width: width,
                qs: 'I am th life of the party',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I don\'t talk a lot',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I feel comfortable around people',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I keep in the background',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I start conversations',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I have little to say.',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I talk to a lot of different people at parties',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I don\'t like to draw attention to myself',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I don\'t mind being the center of attention',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
              question(
                width: width,
                qs: 'I am quiet around strangers',
                grpVal1: groupValue_1,
                grpVal2: groupValue_2,
                grpVal3: groupValue_3,
                grpVal4: groupValue_4,
                grpVal5: groupValue_5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column question({
    double width,
    String qs,
    int grpVal1,
    int grpVal2,
    int grpVal3,
    int grpVal4,
    int grpVal5,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          qs,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff5b055e),
          ),
        ),
        FRadio(
          width: width,
          height: 50,
          value: 1,
          groupValue: grpVal1,
          onChanged: (value) {
            setState(() {
              grpVal1 = value;
            });
          },
          selectedColor: Color(0xffffc900),
          corner: FRadioCorner(leftTopCorner: 0, leftBottomCorner: 0),
          border: 1,
          normalColor: Colors.red,
          // fill: true,
          hasSpace: false,
          selectedChild: Text("Very Inaccurate",
              style: TextStyle(color: Color(0xff333333))),
          child: Text(
            "Very Inaccurate",
          ),
        ),
        FRadio(
          width: width,
          height: 50,
          value: 1,
          groupValue: grpVal2,
          onChanged: (value) {
            setState(() {
              grpVal2 = value;
            });
          },
          selectedColor: Color(0xffffc900),
          corner: FRadioCorner(leftTopCorner: 0, leftBottomCorner: 0),
          border: 1,
          hasSpace: false,
          selectedChild: Text("Moderately Inaccurate",
              style: TextStyle(color: Color(0xff333333))),
          child: Text(
            "Moderately Inaccurate",
          ),
        ),
        FRadio(
          width: width,

          // width: 100,
          height: 50,
          value: 1,
          groupValue: grpVal3,
          onChanged: (value) {
            setState(() {
              grpVal3 = value;
            });
          },
          selectedColor: Color(0xffffc900),
          corner: FRadioCorner(leftTopCorner: 0, leftBottomCorner: 0),
          border: 1,
          hasSpace: false,
          selectedChild: Text("Neither Accurate Nor Inaccurate",
              style: TextStyle(color: Color(0xff333333))),
          child: Text(
            "Neither Accurate Nor Inaccurate",
          ),
        ),
        FRadio(
          width: width,

          // width: 100,
          height: 50,
          value: 1,
          groupValue: grpVal4,
          onChanged: (value) {
            setState(() {
              grpVal4 = value;
            });
          },
          selectedColor: Color(0xffffc900),
          corner: FRadioCorner(leftTopCorner: 0, leftBottomCorner: 0),
          border: 1,
          hasSpace: false,
          selectedChild: Text("Moderately Accurate",
              style: TextStyle(color: Color(0xff333333))),
          child: Text(
            "Moderately Accurate",
          ),
        ),
        FRadio(
          width: width,
          height: 50,
          value: 1,
          groupValue: grpVal5,
          onChanged: (value) {
            setState(() {
              grpVal5 = value;
            });
          },
          selectedColor: Colors.lightGreen,
          corner: FRadioCorner(leftTopCorner: 0, leftBottomCorner: 0),
          border: 1,
          hasSpace: false,
          selectedChild:
              Text("Very Accurate", style: TextStyle(color: Color(0xff333333))),
          child: Text(
            "Very Accurate",
          ),
        ),
      ],
    );
  }
}
