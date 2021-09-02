import 'package:codeforces_visualizer/utilities/constants.dart';
import 'package:codeforces_visualizer/utilities/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kPrimaryColor,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text(
                  "Codeforces",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: GoogleFonts.mateSc().fontFamily),
                ),
                accountEmail: Text(
                  "Visualizer",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: GoogleFonts.mateSc().fontFamily),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/CF.jpg"),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, MyRoute.homeRoute, ModalRoute.withName("/"));
              },
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, MyRoute.singleUserInputPage);
              },
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
              ),
              title: Text(
                "Single User",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, MyRoute.compareUsersInputPage);
              },
              leading: Icon(
                Icons.stacked_line_chart_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Compare Users",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, MyRoute.last10Contests);
              },
              leading: Icon(
                Icons.pie_chart_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Last 10 Contests",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
