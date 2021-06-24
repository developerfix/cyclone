import 'package:cyclone/screens/wrapper.dart';
import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _controller.forward();

    new Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Wrapper()),
            ));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/wrapper');
                    },
                    child: new Text(
                      "Cyclone",
                      style: TextStyle(
                          fontFamily: "Billabong",
                          fontWeight: FontWeight.w600,
                          // fontStyle: FontStyle.italic,
                          fontSize: 60,
                          color: Colors.white),
                    ),
                   
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Column(
                  children: [
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                      child: SvgPicture.asset(
                        'assets/svg/logo.svg',
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Connecting",
                      style: TextStyle(
                          fontFamily: "Billabong",
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
