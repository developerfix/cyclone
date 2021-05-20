import 'package:cyclone/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'book_view_models/app_provider.dart';
import 'book_view_models/details_provider.dart';
import 'book_view_models/favorites_provider.dart';
import 'book_view_models/genre_provider.dart';
import 'book_view_models/home_provider.dart';
import 'models/user.dart';
import 'routes_generate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        MyApp(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => DetailsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => GenreProvider()),
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<List<UserInfo>>.value(
          value: DatabaseServices().userInfo,
        ),
      ],
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return MultiProvider(
              providers: [
                StreamProvider<CycloneUser>.value(
                    initialData: CycloneUser(),
                    value: AuthService().cycloneUser),
              ],
              // StreamProvider<List<UserInfo>>.value(
              // value: DatabaseServices().userInfo,
              child: MaterialApp(
                initialRoute: '/',
                onGenerateRoute: RouteGenerator.generateRoute,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
