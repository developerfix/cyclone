import 'package:cyclone/widgets/customButton.dart';
import 'package:cyclone/widgets/customTextField.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: new Text(
                          "Sign Up",
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
                        icon: Icons.person,
                        text: "FULL NAME",
                      ),
                      CustomTextField(
                        icon: Icons.email,
                        text: "EMAIL",
                      ),
                      CustomTextField(
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
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                    onPress: () {
                      Navigator.pushNamed(context, '/questions');
                    },
                    text: "SIGN UP",
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
                  new Text(
                    "By creating an account, you agree to \n our Terms of Service and Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Color(0xff745ea8),
                    ),
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
