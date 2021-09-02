import 'package:codeforces_visualizer/components/uiElements.dart';
import 'package:codeforces_visualizer/screens/drawer.dart';
import 'package:codeforces_visualizer/utilities/constants.dart';
import 'package:codeforces_visualizer/utilities/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: buildAppBar(),
      backgroundColor: kTextColor,
      body: SingleChildScrollView(
        child: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                emptySpace(size.height * 0.2 - 27),
                Positioned(
                    bottom: 13,
                    left: 10,
                    right: 10,
                    child: codeforcesLogo(size)),
                Positioned(
                  bottom: -20,
                  left: 0,
                  right: 0,
                  child: codeforcesNamedLogo(),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: titleText(
                "Visualizer",
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(indent: 10, endIndent: 10),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homePageButton("  Single User", () {
                  Navigator.pushNamed(context, MyRoute.singleUserInputPage);
                }, Icons.bar_chart),
                SizedBox(height: 40),
                homePageButton("  Compare Users", () {
                  Navigator.pushNamed(context, MyRoute.compareUsersInputPage);
                }, Icons.stacked_line_chart_sharp),
                SizedBox(height: 40),
                homePageButton("  Last 10 Contests", () {
                  Navigator.pushNamed(context, MyRoute.last10Contests);
                }, Icons.pie_chart),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget homePageButton(String text, void Function()? onpress, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
    // child: ListTile(
    //   leading: Icon(icon, color: kTextColor),
    //   title: Text(
    //     text,
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontFamily: GoogleFonts.poppins().fontFamily,
    //       color: kTextColor,
    //     ),
    //   ),
    //   tileColor: kPrimaryColor,
    //   onTap: onpress,
    //   shape: ShapeBorder.lerp(a, b, t),
    // ),

    child: TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kPrimaryColor),
        elevation: MaterialStateProperty.all(0.0),
      ),
      onPressed: onpress,
      child: Row(
        children: [
          Icon(icon, color: kTextColor),
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: kTextColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget titleText(String text) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 35.0,
        color: black,
        fontWeight: FontWeight.w900,
        letterSpacing: 5,
        fontFamily: GoogleFonts.mateSc().fontFamily),
  );
}
