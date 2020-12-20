import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(gradient: linearGradient),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: new Text(
                  "Cyclone updated",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,
                    fontSize: 35,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
