import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimSearchBar extends StatefulWidget {
  ///  width - double ,is@required : Yes
  ///  textController - TextEditingController  ,is@required : Yes
  ///  onSuffixTap - Function, is@required : Yes
  ///  rtl - Boolean, is@required : No
  ///  autoFocus - Boolean, is@required : No
  ///  style - TextStyle, is@required : No
  ///  closeSearchOnSuffixTap - bool , is@required : No
  ///  suffixIcon - Icon ,is@required :  No
  ///  prefixIcon - Icon  ,is@required : No
  ///  animationDurationInMilli -  int ,is@required : No
  ///  helpText - String ,is@required :  No
  /// inputFormatters - TextInputFormatter, @required - No

  final double width;
  final Icon suffixIcon;
  final Icon prefixIcon;
  final String helpText;
  final int animationDurationInMilli;
  final Function onClose;
  final Function onOpen;
  final Function(String) onChanged;
  final bool rtl;
  final bool autoFocus;
  final TextStyle style;
  final Color color;
  final List<TextInputFormatter> inputFormatters;

  ///toggle - 0 => false or closed
  ///toggle 1 => true or open
  int toggle;

  AnimSearchBar({
    Key key,

    /// The width cannot be null
    @required this.width,

    /// The textController cannot be null
    this.suffixIcon,
    this.prefixIcon,
    this.toggle = 0,
    this.helpText = "Search...",

    /// choose your custom color
    this.color = Colors.white,
    @required this.onClose,
    @required this.onOpen,
    @required this.onChanged,
    this.animationDurationInMilli = 375,

    /// make the search bar to open from right to left
    this.rtl = true,

    /// make the keyboard to show automatically when the searchbar is expanded
    this.autoFocus = true,

    /// TextStyle of the contents inside the searchbar
    this.style,

    /// close the search on suffix tap

    /// can add list of inputformatters to control the input
    this.inputFormatters,
  }) : super(key: key);

  @override
  _AnimSearchBarState createState() => _AnimSearchBarState();
}

class _AnimSearchBarState extends State<AnimSearchBar>
    with SingleTickerProviderStateMixin {
  TextEditingController textController;

  ///initializing the AnimationController
  AnimationController _con;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.toggle == 0)
    return Container(
      height: 100.0,

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl ? Alignment.centerRight : Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDurationInMilli),
        height: 48.0,
        width: (widget.toggle == 0) ? 48.0 : widget.width,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom color or the color will be white
          color: widget.color,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: -10.0,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Stack(
          children: [
            ///Using Animated Positioned widget to expand and shrink the widget
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              top: 6.0,
              right: 7.0,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: (widget.toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    /// can add custom color or the color will be white
                    color: widget.color,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: AnimatedBuilder(
                    child: GestureDetector(
                      onTap: () {
                        try {
                          ///trying to execute the onSuffixTap function
                          widget.onClose();

                          ///closeSearchOnSuffixTap will execute if it's true
                          textController.clear();
                          unfocusKeyboard();
                          setState(() {
                            widget.toggle = 0;
                          });
                        } catch (e) {
                          ///print the error if the try block fails
                          print(e);
                        }
                      },

                      ///suffixIcon is of type Icon
                      child: widget.suffixIcon != null
                          ? widget.suffixIcon
                          : Icon(
                              Icons.close,
                              size: 20.0,
                            ),
                    ),
                    builder: (context, widget) {
                      ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                      return Transform.rotate(
                        angle: _con.value * 2.0 * pi,
                        child: widget,
                      );
                    },
                    animation: _con,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              left: (widget.toggle == 0) ? 20.0 : 40.0,
              curve: Curves.easeOut,
              top: 11.0,

              ///Using Animated opacity to change the opacity of th textField while expanding
              child: AnimatedOpacity(
                opacity: (widget.toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.topCenter,
                  width: widget.width / 1.7,
                  child: TextField(
                    ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                    controller: textController,
                    onChanged: widget.onChanged,
                    inputFormatters: widget.inputFormatters,
                    focusNode: focusNode,
                    cursorRadius: Radius.circular(10.0),
                    cursorWidth: 2.0,
                    onSubmitted: (v) {
                      unfocusKeyboard();
                    },

                    ///style is of type TextStyle, the default is just a color black
                    style: widget.style != null
                        ? widget.style
                        : TextStyle(color: Colors.black),
                    cursorColor: Colors.black,

                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.only(bottom: 5),
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: widget.helpText,
                      labelStyle: TextStyle(
                        color: Color(0xff5B5B5B),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Using material widget here to get the ripple effect on the prefix icon
            Material(
              /// can add custom color or the color will be white
              color: widget.color,
              borderRadius: BorderRadius.circular(30.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 20.0,
                ),
                onPressed: widget.toggle == 1
                    ? null
                    : () {
                        widget.onOpen();
                        setState(
                          () {
                            ///if the search bar is closed
                            if (widget.toggle == 0) {
                              widget.toggle = 1;
                              setState(() {
                                ///if the autoFocus is true, the keyboard will pop open, automatically
                                if (widget.autoFocus)
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);
                              });

                              ///forward == expand
                              _con.forward();
                            } else {
                              ///if the search bar is expanded
                              widget.toggle = 0;

                              ///if the autoFocus is true, the keyboard will close, automatically
                              setState(() {
                                if (widget.autoFocus) unfocusKeyboard();
                              });

                              ///reverse == close
                              _con.reverse();
                            }
                          },
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
