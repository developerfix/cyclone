import 'package:cyclone/services/auth.dart';
import 'package:cyclone/services/firebase_ml_custom.dart';
import 'package:cyclone/widgets/customButton.dart';
import 'package:cyclone/widgets/customTextField.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  FirebaseMlCustom firebaseMlCustom = FirebaseMlCustom();
  AuthService _auth = AuthService();

  String username = '';
  String email = '';
  String password = '';
  String error = '';

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
                  children: <Widget>[
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_outlined))
                      ],
                    ),
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
                          isSuffixIcon: false,
                          onChanged: (val) {
                            setState(() {
                              username = val;
                            });
                          },
                          validator: (val) =>
                              val.isEmpty ? 'Enter a username' : null,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.00),
                            topRight: Radius.circular(10.00),
                          ),
                          icon: Icons.person,
                          text: "Username",
                        ),
                        CustomTextField(
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          isSuffixIcon: false,
                          icon: Icons.email,
                          text: "Email",
                        ),
                        // CustomTextField
                        //   validator: (val) => val.isEmpty ? 'Enter an email' :null,

                        //   onChanged: (val) {},
                        //   isSuffixIcon: false,
                        //   icon: Icons.add_call,
                        //   text: "MOBILE NUMBER",
                        // ),
                        CustomTextField(
                          validator: (val) => val.length < 8
                              ? 'Enter at least 8+ chars long password'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          isSuffixIcon: false,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.00),
                            bottomRight: Radius.circular(10.00),
                          ),
                          icon: Icons.lock,
                          text: "Password",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CustomButton(
                      onPress: () async {
                        // firebaseMlCustom.loadModelFromFirebase();
                        if (_formKey.currentState.validate()) {
                          dynamic result =
                              await _auth.registerUserWithEmailAndPassword(
                                  email, username, password);
                          if (result == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Invalid Credentials"),
                                    content: Text(
                                        'Could not sign up with those credentials, Please provide authentic credentials'),
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
                          } else {
                            Navigator.pushNamed(context, '/questions');
                          }
                        }
                      },
                      text: "SIGN UP",
                      textStyle: TextStyle(
                        fontFamily: "Segoe UI",
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xffffffff),
                      ),
                    ),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.red,
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
      ),
    );
  }
}
