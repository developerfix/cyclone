import 'package:flutter/material.dart';
import 'package:Siuu/res/colors.dart';

class Appbar2 extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback close;
  Appbar2({this.title, this.trailing, this.close});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.117,
      decoration: BoxDecoration(
        gradient: linearGradient,
      ),
      child: Column(
        children: [
          //Container(height: height * 0.0585),
          Container(
            height: height * 0.117,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: close),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 19,
                      color: Color(0xffffffff),
                    ),
                  ),
                  trailing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
