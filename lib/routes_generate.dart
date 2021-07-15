import 'package:cyclone/customNewsfeed/views/customNewsFeedHome.dart';
import 'package:cyclone/screens/HomeScreen.dart';
import 'package:cyclone/screens/NewsApi/tabs/sources_screen.dart';
import 'package:cyclone/screens/Podcast_UI/main.dart';
import 'package:cyclone/screens/Questions/Questions.dart';
import 'package:cyclone/screens/Profile Section/profile.dart';
import 'package:cyclone/screens/Profile Section/favs.dart';
import 'package:cyclone/screens/auth/forgot_password.dart';
import 'package:cyclone/screens/auth/login.dart';
import 'package:cyclone/screens/auth/signup.dart';
import 'package:cyclone/screens/book_views/explore/explore.dart';
import 'package:cyclone/screens/chat/chatHome.dart';
import 'package:cyclone/screens/postViews/ArticleView.dart';
import 'package:cyclone/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:cyclone/screens/book_views/favoriteBooks/favoriteBooks.dart';

import 'screens/chat/messages.dart';
import 'screens/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/wrapper':
        return MaterialPageRoute(builder: (_) => Wrapper());
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
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      // case '/BNB':
      //   return MaterialPageRoute(builder: (_) => BottomNavBar());
      case '/messages':
        return MaterialPageRoute(builder: (_) => Messages());
      // case '/chat':
      //   return MaterialPageRoute(builder: (_) => Chat());
      // case '/chat':
      //   return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/explore':
        return MaterialPageRoute(builder: (_) => Explore());
      case '/favs':
        return MaterialPageRoute(builder: (_) => Favs());
      case '/favBooks':
        return MaterialPageRoute(builder: (_) => FavouriteBooks());
      case '/sourcesScreen':
        return MaterialPageRoute(builder: (_) => SourceScreen());
      case '/podcastMainUI':
        return MaterialPageRoute(builder: (_) => PodcastMainUI());
      case '/customNewsfeedHome':
        return MaterialPageRoute(builder: (_) => CustomNewsFeedHome());
      case '/chatHome':
        return MaterialPageRoute(builder: (_) => ChatHome());
      case '/articleView':
        return MaterialPageRoute(
          builder: (_) => ArticleView(
            url: args.toString(),
          ),
        );

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
