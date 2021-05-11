import 'package:cyclone/BNB.dart';
import 'package:cyclone/models/user.dart';
import 'package:cyclone/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CycloneUser>(context);

    //return either home or authentication screen
    if (user == null) {
      return Login();
    } else {
      return BottomNavBar();
    }
  }
}
