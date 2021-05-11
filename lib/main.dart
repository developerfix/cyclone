import 'package:cyclone/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    // MultiProvider(
    //     providers: [
    //       StreamProvider<User>.value(value: AuthService().user),
    //       StreamProvider<List<UserInfo>>.value(
    //         value: DatabaseServices().userInfo,
    //       ),
    //     ],
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return MultiProvider(
              providers: [
                StreamProvider<CycloneUser>.value(
                    // initialData:,
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
