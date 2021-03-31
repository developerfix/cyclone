import 'package:cyclone/screens/auth/signup.dart';
import 'package:cyclone/widgets/customButton.dart';
import 'package:cyclone/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cyclone/utils/res.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: new Text(
                          "Log In",
                          style: TextStyle(
                            fontFamily: "Segoe UI",
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Color(0xff515c6f),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: <Widget>[
                      CustomTextField(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.00),
                          topRight: Radius.circular(10.00),
                        ),
                        icon: Icons.add_call,
                        text: "MOBILE NUMBER",
                      ),
                      CustomTextField(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.00),
                          bottomRight: Radius.circular(10.00),
                        ),
                        icon: Icons.lock,
                        text: "PASSWORD",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              child: new Text(
                                "Forgot Password?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Segoe UI",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Color(0xff515c6f),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),

                  CustomButton(
                    onPress: () {
                      Navigator.pushNamed(context, '/BNB');
                    },
                    text: "LOG IN",
                    textStyle: TextStyle(
                      fontFamily: "Segoe UI",
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Color(0xffffffff),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  // Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                    child: new Text(
                      "Don’t have an account? Click here \n create a new account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Color(0xff745ea8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SvgPicture.asset(
                        facebookLogo,
                        height: height * 0.065,
                        width: width * 0.109,
                      ),
                      SvgPicture.asset(
                        googlePlusLogo,
                        height: height * 0.065,
                        width: width * 0.109,
                      ),
                      SvgPicture.asset(
                        twitterLogo,
                        height: height * 0.065,
                        width: width * 0.109,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
