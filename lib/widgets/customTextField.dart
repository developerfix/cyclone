import 'package:flutter/material.dart';
import 'package:cyclone/utils/res.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final IconData icon;
  final BorderRadius borderRadius;
  CustomTextField({this.text, this.icon, this.borderRadius});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return new Container(
      height: height * 0.111,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 8.00),
            color: Color(0xffe7eaf0),
            blurRadius: 15,
          ),
        ],
        borderRadius: this.borderRadius,
      ),
      child: Center(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: this.text,
            hintStyle: TextStyle(
              fontFamily: "Segoe UI",
              fontSize: 12,
              color: Color(0xff515c6f).withOpacity(0.50),
            ),
            prefixIcon: Icon(
              this.icon,
              color: Color(greyish),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
