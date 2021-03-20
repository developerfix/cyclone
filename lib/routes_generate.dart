import 'package:cyclone/auth/forgot_password.dart';
import 'package:cyclone/auth/login.dart';
import 'package:cyclone/auth/signup.dart';
import 'package:cyclone/screens/HomeScreen.dart';
import 'package:cyclone/BNB.dart';
import 'package:cyclone/screens/Questions/Questions.dart';
import 'package:cyclone/screens/Topics/TopicDetails.dart';
import 'package:cyclone/screens/Topics/Topics.dart';
import 'package:cyclone/screens/Profile Section/profile.dart';
import 'package:cyclone/screens/chat/chat.dart';
import 'package:cyclone/screens/customNewsfeed/customNewsfeed.dart';
import 'package:flutter/material.dart';

import 'screens/chat/messages.dart';
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
      case '/questions':
        return MaterialPageRoute(builder: (_) => Questions());
      case '/forgotPassword':
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case '/homeScreen':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/topics':
        return MaterialPageRoute(builder: (_) => Topics());
      case '/customNewsfeed':
        return MaterialPageRoute(builder: (_) => CustomNewsfeed());
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case '/BNB':
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case '/topicDetails':
        return MaterialPageRoute(builder: (_) => TopicDetails());
      case '/messages':
        return MaterialPageRoute(builder: (_) => Messages());
      case '/chat':
        return MaterialPageRoute(builder: (_) => Chat());

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
