import 'dart:ui';
import 'package:Siuu/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;

  final Function onPressed;
  const CustomDialogBox(
      {Key key, this.title, this.descriptions, this.text, this.onPressed})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  static const double padding = 20;
  static const double avatarRadius = 45;

  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  ValueNotifier<bool> isPresed = ValueNotifier(false);

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: padding, top: padding, right: padding, bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundedLoadingButton(
                      controller: _btnController,
                      color: Color(pinkColor),
                      elevation: 0,
                      onPressed: () async {
                        if (isPresed.value) return;
                        isPresed.value = true;
                        _btnController.start();
                        await widget.onPressed();
                        _btnController.stop();
                        isPresed.dispose();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: isPresed,
                      builder: (_, val, __) {
                        if (val) return Container();
                        return Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 40),
                              Expanded(
                                child: RoundedLoadingButton(
                                  controller: RoundedLoadingButtonController(),
                                  duration: Duration(seconds: 0),
                                  color: Colors.grey,
                                  elevation: 0,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
        // Positioned(
        //   left: padding,
        //   right: padding,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.amber,
        //     radius: avatarRadius,
        //     child: Icon(
        //       Icons.warning_amber_rounded,
        //       color: Colors.white,
        //       size: avatarRadius,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
