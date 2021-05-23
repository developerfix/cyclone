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
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => DetailsProvider()),
            ChangeNotifierProvider(create: (_) => FavoritesProvider()),
            ChangeNotifierProvider(create: (_) => GenreProvider()),

            StreamProvider<CycloneUser>.value(
                initialData: CycloneUser(uid: ''),
                value: AuthService().cycloneUser),
            // StreamProvider<List<UserInfo>>.value(
            //   value: DatabaseServices().userInfo,
            // ),
          ],
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of this application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Consumer<AppProvider>(
              builder: (BuildContext context, AppProvider appProvider,
                  Widget child) {
                return MaterialApp(
                  key: appProvider.key,
                  navigatorKey: appProvider.navigatorKey,
                  initialRoute: '/',
                  onGenerateRoute: RouteGenerator.generateRoute,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.purple,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
