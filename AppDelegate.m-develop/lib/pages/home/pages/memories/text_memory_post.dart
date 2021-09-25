import 'dart:math';

import 'package:Siuu/models/post_text.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/widgets/limited_text.dart';
import 'package:Siuu/widgets/tiles/loading_indicator_tile.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:google_fonts/google_fonts.dart';

typedef IntCallback = Function(PostText textMeta);

class TextMemoryPost extends StatefulWidget {
  IntCallback onWrited;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  ValueChanged<String> onBackgroudSelect;
  ValueNotifier<Widget> stickyWidget;
  bool isPost;

  TextMemoryPost({
    this.onWrited,
    this.controller,
    this.focusNode,
    this.hintText,
    this.onBackgroudSelect,
    this.stickyWidget,
    this.isPost = false,
  });

  @override
  _TextMemoryPostState createState() => _TextMemoryPostState();
}

class _TextMemoryPostState extends State<TextMemoryPost> {
  bool isPng;
  bool isSvg;
  bool isColor;
  int color;
  TextEditingController _textController = TextEditingController();
  bool isfontColorWhite;
  PostText textMeta;
  LinearGradient gradient;

  bool isExpanded;
  String imagePath;

  Widget expressYourselfPost;
/*


                          fontFamily: "Segoe UI",
                          fontWeight: FontWeight.w300,
                          fontSize: fontSize + 5,
                          height: textHeight,
                          color: textMeta.isfontColorWhite
                              ? Colors.white
                              : Colors.black,
 */
  final double textHeight = 1;
  final double fontSize = 35;
  TextStyle currentFont;
  int _currentFontId;
  final List<TextStyle> fonts = [
    GoogleFonts.openSans(
      fontWeight: FontWeight.w300,
      fontSize: 35,
      height: 1,
    ),
    GoogleFonts.rozhaOne(
      fontWeight: FontWeight.w300,
      fontSize: 35,
      height: 1,
    ),
    GoogleFonts.bungeeShade(
      fontWeight: FontWeight.w300,
      fontSize: 35,
      height: 1,
    ),
    GoogleFonts.architectsDaughter(
      fontWeight: FontWeight.w300,
      fontSize: 35,
      height: 1,
    ),
    GoogleFonts.pirataOne(
      fontWeight: FontWeight.w300,
      fontSize: 35,
      height: 1,
    ),
    GoogleFonts.akronim(
      fontWeight: FontWeight.w300,
      fontSize: 35,
      height: 1,
    ),
  ];

  Future<Widget> backgroundList;

  void keyboardController() {
    if (widget.focusNode.hasFocus) {
      widget.stickyWidget.value = buildBackgroundList();
    } else {
      widget.stickyWidget.value = Container(
        height: 0,
      );
    }
  }

  @override
  void didChangeDependencies() {
    widget.stickyWidget.value = buildBackgroundList();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityController keyboardVisibilityController =
        new KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (widget.focusNode.hasFocus && !visible) {
        widget.focusNode.unfocus();
      }
    });
    currentFont = fonts[0];
    _currentFontId = 0;
    widget.focusNode.addListener(keyboardController);

    imagePath = '';
    expressYourselfPost = Container();
    isfontColorWhite = false;
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.white],
    );
    isPng = false;
    isSvg = false;
    isColor = true;
    color = 0xffffffff;
    isExpanded = false;
    final String defaultBackground = 'assets/svg/heart3.svg';
    textMeta = new PostText(
        color: 0xffffffff,
        gradient: [Colors.white, Colors.white],
        imagePath: widget.isPost ? null : defaultBackground,
        isExpanded: false,
        isColor: widget.isPost,
        isPng: false,
        isSvg: widget.isPost ? false : true,
        isfontColorWhite: widget.isPost ? false : true,
        text: '');
    if (widget.onBackgroudSelect != null)
      widget
          .onBackgroudSelect(widget.isPost ? Colors.white : defaultBackground);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(keyboardController);
    widget.stickyWidget.value = Container(
      height: 0,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final int maxLine = (height / 2) ~/ (fontSize * textHeight);
    print('Max line is: $maxLine');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (backgroundList == null)
        backgroundList = backgroundListFutureBuilder();
    });
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 20,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height / 2,
                    maxWidth: width,
                    minHeight: height / 3,
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: textMeta.isColor
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: textMeta.gradient,
                              )
                            : null,
                      ),
                      child: textMeta.isSvg
                          ? SvgPicture.asset(
                              textMeta.imagePath,
                              fit: BoxFit.cover,
                            )
                          : textMeta.isPng
                              ? Image.asset(
                                  textMeta.imagePath,
                                  fit: BoxFit.cover,
                                )
                              : null),
                ),
              ),
              Container(
                height: width - 50,
                width: width,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                alignment: Alignment.center,
                child: AutoSizeTextField(
                  //controller: _textController,
                  scrollPadding: EdgeInsets.zero,
                  keyboardType: TextInputType.multiline,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  onChanged: (String newText) {
                    /*if (('\n'.allMatches(newText).length + 1) >= maxLine - 2) {
                        ToastService().error(
                            message: 'Maximum line is: ${maxLine - 2}',
                            context: context);
                        print('Prev text is: ${widget.controller.text}');
                        print('And current text is: ${newText}');
                        return;
                      }
    */
                    /*final bool canWrite = LimitedText(
                        newText,
                        widgetStyle: TextStyle(
                          fontFamily: currentFont.fontFamily,
                          fontSize: currentFont.fontSize,
                          fontWeight: currentFont.fontWeight,
                          color: textMeta.isfontColorWhite
                              ? Colors.white
                              : Colors.black,
                        ),
                        widgetTextAlign: TextAlign.center,
                        widgetTrimLines: maxLine - 4,
                        maxWidth: width,
                        maxHeight: height,
                        widgetTextScaleFactor:
                            MediaQuery.textScaleFactorOf(context) ?? 1.0,
                      ).canWrite(context);
                      if (canWrite == false) {
                        widget.controller.text =
                            newText.substring(0, newText.length - 1);
                        widget.controller.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: widget.controller.text.length),
                        );
                        return;
                      }*/
                    textMeta.text = newText;

                    if (widget.onWrited != null) widget.onWrited(textMeta);
                  },
                  maxFontSize: currentFont.fontSize - 5,
                  maxLines: null,
                  // maxLength: 200,
                  //maxLength: ,
                  //textDirection: ,
                  controller: widget.controller,
                  autofocus: true,
                  focusNode: widget.focusNode,
                  style: TextStyle(
                    fontFamily: currentFont.fontFamily,
                    fontSize: currentFont.fontSize,
                    fontWeight: currentFont.fontWeight,
                    color:
                        textMeta.isfontColorWhite ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, -25),
                    hintText: '#Siuuuuuuuuuuu now',
                    hintStyle: TextStyle(
                      fontFamily: currentFont.fontFamily,
                      fontSize: currentFont.fontSize,
                      fontWeight: currentFont.fontWeight,
                      color: textMeta.isfontColorWhite
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 20,
          ),
          ValueListenableBuilder<Widget>(
            valueListenable: widget.stickyWidget,
            builder: (context, stickyWidget, child) {
              if (stickyWidget is Container) {
                return buildBackgroundList();
              } else {
                return Container(
                  height: height * 0.043 + 50,
                );
              }
            },
          ),

          /*Positioned(
              right: 20,
              top: 30,
              child: InkWell(
                onTap: () {},
                child: Text(
                  "Share",
                  style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: textMeta.isfontColorWhite
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),*/
        ],
      ),
    );
  }

  InkWell imageBox({String boxImagePath, String fontColor}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          textMeta.isSvg = true;
          textMeta.isPng = false;
          textMeta.isColor = false;
          fontColor == 'white'
              ? textMeta.isfontColorWhite = true
              : textMeta.isfontColorWhite = false;
          textMeta.imagePath = boxImagePath;
        });
        if (widget.onBackgroudSelect != null) {
          widget.onBackgroudSelect(textMeta.imagePath);
        }
        // print("this is background:3:${textMeta.imagePath}");

        widget.onWrited(textMeta);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: height * 0.0365,
          width: width * 0.083,
          child: SvgPicture.asset(
            boxImagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  InkWell coloredBox({int boxColor, String fontColor}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(
          () {
            gradient = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(boxColor), Colors.white],
            );
            textMeta.gradient = [Color(boxColor), Colors.white];
            fontColor == 'white'
                ? textMeta.isfontColorWhite = true
                : textMeta.isfontColorWhite = false;
            textMeta.isColor = true;
            textMeta.isSvg = false;
            textMeta.isPng = false;
            textMeta.color = fontColor == 'white' ? 0xDD000000 : 0xffffffff;
          },
        );
        if (widget.onBackgroudSelect != null) {
          widget.onBackgroudSelect('color:${boxColor.toString()}');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(boxColor), Colors.white],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        height: height * 0.0365,
        width: width * 0.083,
      ),
    );
  }

  Future<Widget> backgroundListFutureBuilder() async {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Future.microtask(
      () {
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: height * 0.043,
                child: Row(
                  children: [
                    /*Container(
                  height: height * 0.043,
                  width: width * 0.0729,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5, color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.blueGrey,
                  ),
                ),*/
                    /*SizedBox(
                  width: width * 0.012,
                ),*/
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (widget.isPost)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black54,
                                  ),
                                ),
                                child: coloredBox(
                                    boxColor: 0xffffffff, fontColor: 'black'),
                              ),
                            if (widget.isPost)
                              SizedBox(
                                width: width * 0.024,
                              ),
                            coloredBox(
                                boxColor: 0xff293DA8, fontColor: 'white'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath:
                                    'assets/svg/abstractBackground.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            coloredBox(
                                boxColor: 0xffA32775, fontColor: 'white'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/abstraction.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            coloredBox(
                                boxColor: 0xffDD15B5, fontColor: 'white'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/giraffe.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            coloredBox(
                                fontColor: 'white', boxColor: 0xff1549DD),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/heart3.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/hearts2.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/lines.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/lines2.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/love.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'black',
                                boxImagePath:
                                    'assets/svg/oldSchoolMusicBackground.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/planets.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            imageBox(
                                fontColor: 'white',
                                boxImagePath: 'assets/svg/triangles.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.012,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildBackgroundList() {
    return FutureBuilder<Widget>(
      future: backgroundList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data;
        } else {
          return Container(
            width: 20,
            height: 20,
            child: OBLoadingIndicatorTile(),
          );
        }
      },
    );
  }
}

class MaxLinesTextInputFormatter extends TextInputFormatter {
  MaxLinesTextInputFormatter(this.maxLines)
      : assert(maxLines == null || maxLines == -1 || maxLines > 0);

  final int maxLines;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    if (maxLines != null && maxLines > 0) {
      final regEx = RegExp("^.*((\n?.*){0,${maxLines - 1}})");
      String newString = regEx.stringMatch(newValue.text) ?? "";

      final maxLength = newString.length;
      print('Max length: $maxLength newLength: ${newValue.text.runes.length}');
      if (newValue.text.runes.length > maxLength) {
        final TextSelection newSelection = newValue.selection.copyWith(
          baseOffset: min(newValue.selection.start, maxLength),
          extentOffset: min(newValue.selection.end, maxLength),
        );
        final RuneIterator iterator = RuneIterator(newValue.text);
        if (iterator.moveNext())
          for (int count = 0; count < maxLength; ++count)
            if (!iterator.moveNext()) break;
        final String truncated = newValue.text.substring(0, iterator.rawIndex);

        return TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
      }
      return newValue;
    }
    return newValue;
  }
}
