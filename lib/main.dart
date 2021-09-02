import 'package:codeforces_visualizer/homePage.dart';
import 'package:codeforces_visualizer/screens/compare_users.dart';
import 'package:codeforces_visualizer/screens/last_10_contests.dart';
import 'package:codeforces_visualizer/screens/single_user.dart';
import 'package:codeforces_visualizer/utilities/constants.dart';
import 'package:codeforces_visualizer/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Codeforces Visualizer',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MyRoute.homeRoute, //initial route
      routes: {
        "/": (context) => HomePage(), //default route
        MyRoute.homeRoute: (context) => HomePage(),
        MyRoute.singleUserInputPage: (context) => SingleUserInputPage(),
        MyRoute.compareUsersInputPage: (context) => CompareUsersInputPage(),
        MyRoute.last10Contests: (context) => Last10ContestsAnalysis(),
      },
    );
  }
}
