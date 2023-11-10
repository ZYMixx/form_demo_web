import 'package:flutter/material.dart';
import 'package:form_demo_web/data/firebase/fire_database.dart';
import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/services/service_shared_preferences.dart';
import 'package:form_demo_web/presentation/launch_screen.dart';

class App {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void start() async {
    navigatorKey = GlobalKey<NavigatorState>();
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: true,
        navigatorKey: navigatorKey,
        theme: ThemeData.light(),
        home: const LaunchScreen(),
      ),
    );
    await FireDatabase.init();
    await ConstantsData.reLoadAllDataBaseData();
    await ServiceSharedPreferences.init();
  }
}
