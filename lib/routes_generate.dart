import 'package:cyclone/auth/forgot_password.dart';
import 'package:cyclone/auth/login.dart';
import 'package:cyclone/auth/signup.dart';
import 'package:flutter/material.dart';

import 'screens/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/forgotPassword':
        return MaterialPageRoute(builder: (_) => ForgotPassword());

      // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
