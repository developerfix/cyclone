import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PostContainer extends StatefulWidget {
  final String title;
  final String category;
  final String publisherPicturePath;
  final String contentPicturePath;
  final Function onPressed;
  final bool isCustomNewsfeedContainer;
  PostContainer(
      {this.category,
      this.isCustomNewsfeedContainer,
      this.contentPicturePath,
      this.publisherPicturePath,
      this.onPressed,
      this.title});

  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          width: width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 10,
                      backgroundImage: AssetImage(widget.publisherPicturePath),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Color(0xff242424),
                          ),
                        ),
                        new Text(
                          widget.category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 8,
                            color: Color(0xffb8b3af),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          widget.isCustomNewsfeedContainer
                              ? showMaterialModalBottomSheet(
                                  // backgroundColor: Colors.red,
                                  context: context,
                                  builder: (context) => Container(
                                    height: 200,
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildText(
                                          fontSize: 15,
                                          color: 0xDD000000,
                                          text: 'Report..',
                                        ),
                                        buildText(
                                          text: 'Not Interested',
                                          fontSize: 15,
                                          color: 0xDD000000,
                                        ),
                                        buildText(
                                          text: 'Copy Link',
                                          fontSize: 15,
                                          color: 0xDD000000,
                                        ),
                                      ],
                                    ),
                                    // color: Colors.,
                                  ),
                                )
                              : showMaterialModalBottomSheet(
                                  // backgroundColor: Colors.red,
                                  context: context,
                                  builder: (context) => Container(
                                    height: 200,
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildText(
                                          fontSize: 15,
                                          color: 0xDD000000,
                                          text: 'Report..',
                                        ),
                                        buildText(
                                          fontSize: 15,
                                          color: 0xDD000000,
                                          text: 'Add to Specific',
                                        ),
                                        buildText(
                                          text: 'Not Interested',
                                          fontSize: 15,
                                          color: 0xDD000000,
                                        ),
                                        buildText(
                                          text: 'Copy Link',
                                          fontSize: 15,
                                          color: 0xDD000000,
                                        ),
                                      ],
                                    ),
                                    // color: Colors.,
                                  ),
                                );
                        },
                        child: Icon(Icons.more_vert))
                  ],
                ),
              ),
              SizedBox(
                width: width,
                height: 300,
                child: Image.network(
                  widget.contentPicturePath,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset('assets/svg/U.svg'),
                        SizedBox(width: 2),
                        buildText(color: greyish, fontSize: 10, text: '10'),
                        SizedBox(width: 10),
                        SvgPicture.asset('assets/svg/useless.svg'),
                        SizedBox(width: 2),
                        buildText(color: greyish, fontSize: 10, text: '7'),
                        SizedBox(width: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset('assets/svg/O.svg'),
                            buildText(
                                color: 0xff000000,
                                fontSize: 14,
                                text: 'pinion'),
                            SizedBox(width: 2),
                            buildText(color: greyish, fontSize: 10, text: '7'),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    SvgPicture.asset('assets/svg/share.svg'),
                    SizedBox(width: 10),
                    SvgPicture.asset('assets/svg/save.svg'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildText({String text, double fontSize, int color}) {
    return new Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
