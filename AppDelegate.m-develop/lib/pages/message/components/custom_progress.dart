import 'package:Siuu/res/colors.dart';
import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Color(pinkColor),
      ),
    );
  }
}
