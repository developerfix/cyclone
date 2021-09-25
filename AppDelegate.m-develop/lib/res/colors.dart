import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int greyishColor = 0xffF0F6F0;
const int purpleColor = 0xff4D0CBB;
const int pinkColor = 0xffFD0767;
const int accentColor = 0xFFFFEFEE;
const int accentColor2 = 0xFFFEF9EB;

Gradient linearGradient = LinearGradient(
  // List: [
  //   Color(purpleColor),
  //   Color(pinkColor),
  // ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  // stops: [0.5, 0.5],
  colors: [
    Color(purpleColor),
    Color(pinkColor),
  ],
);

Gradient allViewedGradient = LinearGradient(
  // List: [
  //   Color(purpleColor),
  //   Color(pinkColor),
  // ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  // stops: [0.5, 0.5],
  colors: [
    Colors.grey[600],
    Colors.grey[600],
  ],
);
