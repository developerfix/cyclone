import 'package:cyclone/models/user.dart';
import 'package:cyclone/screens/HomeScreen.dart';
import 'package:cyclone/screens/auth/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CycloneUser>(context);
    print(user);
    //return either home or authentication screen
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
