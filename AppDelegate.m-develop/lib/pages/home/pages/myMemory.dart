import 'package:Siuu/pages/home/widgets/lottieStickers.dart';
import 'package:Siuu/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'dart:math' as math;

class MyMemory extends StatefulWidget {
  final Widget crew;

  MyMemory({this.crew});
  @override
  _MyMemoryState createState() => _MyMemoryState();
}

class _MyMemoryState extends State<MyMemory> {
  final formKey = GlobalKey<FormState>();

  bool expandViews;
  bool crewLongPress;

  bool isFollowed;

  @override
  void initState() {
    super.initState();
    isFollowed = false;
    expandViews = false;
    crewLongPress = false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      crewLongPress = true;
                    });
                  },
                  onLongPressEnd: (details) {
                    setState(() {
                      crewLongPress = false;
                    });
                  },
                  child: Image.asset(
                    'assets/images/bgImage.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.029),
                    FlutterSlider(
                      disabled: true,
                      handler: FlutterSliderHandler(
                        child: Container(),
                      ),
                      trackBar: FlutterSliderTrackBar(),
                      values: [40],
                      hatchMark: FlutterSliderHatchMark(disabled: true),
                      handlerHeight: 0,
                      handlerWidth: 0,
                      max: 100,
                      min: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/photo1.png'),

                                  ),
                                  shape: BoxShape.circle),
                              height: height * 0.051,
                              width: width * 0.085,
                            ),
                            SizedBox(width: width * 0.024),
                            buildText(text: '_wecreate_', color: Colors.white),
                            SizedBox(width: width * 0.024),
                            buildText(
                              text: '1h',
                              color: Color(0xffffffff).withOpacity(0.70),
                            ),
                          ],
                        ),
                        IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: null)
                      ],
                    )
                  ],
                ),
              ),
              crewLongPress
                  ? Container()
                  : Positioned(
                      bottom: 0,
                      child: Container(
                        color: Colors.transparent,
                        height: height * 0.658,
                        width: width,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                buildCommentsRow(comment: 'beautiful Picture'),
                                buildCommentsRow(
                                    comment:
                                        'Lorem Ipsum is simply dummy text '),
                                buildCommentsRow(
                                    comment:
                                        'It is a long established fact that a reader will\nbe distracted by the readable content '),
                                buildCommentsRow(comment: 'beautiful Picture'),
                                buildCommentsRow(
                                    comment:
                                        'ly five centuries, but also the leap'),
                                buildCommentsRow(comment: 'beautiful Picture'),
                                buildCommentsRow(comment: 'beautiful Picture'),
                                buildCommentsRow(comment: 'beautiful Picture'),
                                buildCommentsRow(comment: 'beautiful Picture'),
                                buildCommentsRow(comment: 'beautiful Picture'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              expandViews
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        height: height * 0.658,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      expandViews = false;
                                    });
                                  },
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Icon(Icons.arrow_back_ios,
                                        color: Colors.white),
                                  ),
                                ),
                                buildView(id: 1),
                                buildView(id: 2),
                                buildView(),
                                buildView(),
                                buildView(id: 5),
                                buildView(),
                                buildView(),
                                buildView(),
                                buildView(),
                              ],
                            ),
                            // Spacer(),
                          ),
                        ),
                      ),
                    )
                  : crewLongPress
                      ? Container()
                      : Positioned(
                          bottom: 0,
                          child: keyboardVisible == 0
                              ? Container(
                                  height: height * 0.131,
                                  width: width,
                                  color: Colors.black.withOpacity(0.5),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                expandViews = true;
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle: 180 * math.pi / 360,
                                                  child: Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.white),
                                                ),
                                                buildText(
                                                    color: Colors.white,
                                                    text: '20 Views')
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: buildTextField(height, width),
                                        ),
                                        SizedBox(width: width * 0.072),
                                        SvgPicture.asset('assets/svg/like.svg',
                                            height: height * 0.058),
                                        SizedBox(width: width * 0.024),
                                        SvgPicture.asset(
                                            'assets/svg/dislike.svg',
                                            height: height * 0.058),
                                        SizedBox(width: width * 0.024),
                                        SvgPicture.asset(
                                            'assets/svg/heartReact.svg',
                                            height: height * 0.058),
                                        SizedBox(width: width * 0.024),
                                        SvgPicture.asset(
                                            'assets/svg/brokenHeart.svg',
                                            height: height * 0.058),
                                        SizedBox(width: width * 0.024),
                                        SvgPicture.asset('assets/svg/haha.svg',
                                            height: height * 0.058),
                                        SizedBox(width: width * 0.024),
                                        SvgPicture.asset('assets/svg/shock.svg',
                                            height: height * 0.058),
                                        SizedBox(width: width * 0.024),
                                        SvgPicture.asset('assets/svg/smirk.svg',
                                            height: height * 0.058),
                                        SizedBox(width: width * 0.024),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    LottieStickers(width: width),
                                    Container(
                                      height: height * 0.131,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/storyCamera.svg'),
                                          buildTextField(height, width),
                                          SvgPicture.asset(
                                              'assets/svg/storyMsgSendIcon.svg'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildView({int id}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/friend1.png'),
              ),
              SizedBox(width: width * 0.024),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: linearGradient
                    // color: Colors.grey.shade400.withOpacity(0.3),
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      buildText(text: 'John doe', color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          id == 2 || id == 5
              ? SvgPicture.asset(
                  'assets/svg/comment.svg',
                  height: height * 0.049,
                  color: Colors.white,
                )
              : InkWell(
                  onTap: () {
                    setState(
                      () {
                        if (id == 1) {
                          isFollowed ? isFollowed = false : isFollowed = true;
                        }
                      },
                    );
                  },
                  child: id == 1
                      ? isFollowed
                          ? ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return linearGradient.createShader(bounds);
                              },
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 34.0,
                              ),
                            )
                          : Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 34.0,
                            )
                      : Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 34.0,
                        ),
                )
        ],
      ),
    );
  }

  Padding buildCommentsRow({String comment}) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/friend1.png'),
          ),
          SizedBox(width: width * 0.048),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade400.withOpacity(0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(text: 'John doe', color: Colors.white),
                  buildText(text: comment, color: Colors.grey.shade400)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildTextField(double height, double width) {
    return Container(
      height: height * 0.064,
      width: width * 0.709,
      decoration: BoxDecoration(
        border: Border.all(
          width: width * 0.002,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        key: formKey,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          hintText: 'Comment...',
          hintStyle: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }

  Text buildText({String text, Color color}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 13,
        color: color,
      ),
    );
  }
}