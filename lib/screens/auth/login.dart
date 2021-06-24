import 'package:cyclone/screens/auth/signup.dart';
import 'package:cyclone/services/auth.dart';
import 'package:cyclone/widgets/customButton.dart';
import 'package:cyclone/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cyclone/utils/res.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';
  final bar = SnackBar(content: Text('Hello, world!'));

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SizedBox(
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
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          isSuffixIcon: false,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.00),
                            topRight: Radius.circular(10.00),
                          ),
                          icon: Icons.email,
                          text: "Email",
                        ),
                        CustomTextField(
                          validator: (val) => val.length < 8
                              ? 'Enter at least 8+ chars long password'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          isSuffixIcon: true,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.00),
                            bottomRight: Radius.circular(10.00),
                          ),
                          icon: Icons.lock,
                          text: "Password",
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
                      onPress: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Invalid Credentials"),
                                    content: Text(
                                        'Could not sign in with those credentials'),
                                    actions: [
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
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
                        InkWell(
                          onTap: () async {
                            await _auth.handleFacebookLogin();
                            // if (result == null) {
                            //   showTopSnackBar(
                            //     context,
                            //     CustomSnackBar.error(
                            //       message:
                            //           "Something went wrong. Please check your credentials and try again",
                            //     ),
                            //   );
                            // }
                          },
                          child: SvgPicture.asset(
                            facebookLogo,
                            height: height * 0.065,
                            width: width * 0.109,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            dynamic result = await _auth.handleGoogleSignIn();
                            if (result == null) {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message:
                                      "Something went wrong. Please check your credentials and try again",
                                ),
                              );
                            }
                          },
                          child: SvgPicture.asset(
                            googleIcon,
                            height: height * 0.065,
                            width: width * 0.109,
                          ),
                        ),
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
      ),
    );
  }
}
