import 'package:cyclone/Podcast/services/settings/mobile_settings_service.dart';
import 'package:cyclone/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
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

  Logger.root.level = Level.FINE;

  Logger.root.onRecord.listen((record) {
    print(
        '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record.message}');
  });
  var _mobileSettingsService = await MobileSettingsService.instance();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        MultiProvider(
          providers: [
            Provider<MobileSettingsService>(
                create: (_) => _mobileSettingsService),
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => DetailsProvider()),
            ChangeNotifierProvider(create: (_) => FavoritesProvider()),
            ChangeNotifierProvider(create: (_) => GenreProvider()),
            StreamProvider<CycloneUser>.value(
                initialData: CycloneUser(uid: ''),
                value: AuthService().cycloneUser),
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
                  theme: themeData(appProvider.theme),
                  // ThemeData(
                  //   primarySwatch: Colors.purple,
                  //   visualDensity: VisualDensity.adaptivePlatformDensity,
                  // ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
        // textTheme: GoogleFonts.sourceSansProTextTheme(
        // theme.textTheme,

        );
  }
}
