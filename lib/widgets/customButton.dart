import 'package:flutter/material.dart';
import 'package:cyclone/utils/res.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final TextStyle textStyle;
  CustomButton({this.text, this.onPress, this.textStyle});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: this.onPress,
      child: new Container(
        height: height * 0.067,
        width: width * 0.802,
        decoration: BoxDecoration(
          gradient: linearGradient,
          boxShadow: [
            BoxShadow(
              offset: Offset(0.00, 5.00),
              color: Color(0xffff6969).withOpacity(0.40),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(this.text, style: this.textStyle)),
        ),
      ),
    );
  }
}
