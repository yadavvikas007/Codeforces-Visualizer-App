import 'package:codeforces_visualizer/components/appbar.dart';
import 'package:codeforces_visualizer/components/uiElements.dart';
import 'package:codeforces_visualizer/screens/drawer.dart';
import 'package:codeforces_visualizer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'compare_users_details_page.dart';

class CompareUsersInputPage extends StatefulWidget {
  const CompareUsersInputPage({Key? key}) : super(key: key);

  @override
  _CompareUsersInputPageState createState() => _CompareUsersInputPageState();
}

class _CompareUsersInputPageState extends State<CompareUsersInputPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: buildAppBar(),
        body: Body(),
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
  //to store input user handles
  String _handle1 = "";
  String _handle2 = "";

  //form key
  final _formKey = GlobalKey<FormState>();

  //for search button animation
  bool changeButton = false;

  //to check for valid inputs
  bool isValid1 = false;
  bool isValid2 = false;

  //input validator function for user1 textfield
  validateUser1() async {
    var url =
        Uri.https("www.codeforces.com", "/api/user.info?handles=$_handle1");
    //checking the entered user handle by calling userinfo API
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse["result"].isEmpty) {
        //if no userinfo data recieved
        isValid1 = false;
      } else {
        isValid1 = true;
      }
    }
  }

  //input validator function for user1 textfield
  validateUser2() async {
    var url =
        Uri.https("www.codeforces.com", "/api/user.info?handles=$_handle2");
    //checking the entered user handle by calling userinfo API
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse["result"].isEmpty) {
        //if no userinfo data recieved
        isValid2 = false;
      } else {
        isValid2 = true;
      }
    }
  }

  //passing valid user handles to comparison page
  movetoComparePage(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      //validate current entries
      setState(() {
        changeButton = true;
      });
      //ab 1 sec to dena pdega na button animation dikhane k liye
      await Future.delayed(Duration(seconds: 1));

      //moving to comparison page
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              CompareUserDetailsPage(handle1: _handle1, handle2: _handle2),
        ),
        ModalRoute.withName("/"),
      );
      //reseting the data before moving to next page
      setState(() {
        changeButton = false;
        _handle1 = "";
        _handle2 = "";
        isValid1 = false;
        isValid2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: size.height * 0.3,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: kPadding, right: kPadding, bottom: 36 + kPadding),
                    height: size.height * 0.3 - 27,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 115,
                    left: 10,
                    right: 10,
                    child: codeforcesLogo(size),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: kPadding),
                      padding: EdgeInsets.symmetric(horizontal: kPadding),
                      alignment: Alignment.center,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.23),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                _handle1 = value;
                                validateUser1();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Username cannot be empty";
                                } else if (!isValid1) {
                                  return "Invalid Username";
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.grey[900]),
                              decoration: InputDecoration(
                                hintText: "User1",
                                hintStyle: TextStyle(
                                  color: kPrimaryColor.withOpacity(0.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/images/search.svg"),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: kPadding),
                      padding: EdgeInsets.symmetric(horizontal: kPadding),
                      alignment: Alignment.center,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.23),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                _handle2 = value;
                                validateUser2();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Username cannot be empty";
                                } else if (!isValid2) {
                                  return "Invalid Username";
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.grey[900]),
                              decoration: InputDecoration(
                                hintText: "User2",
                                hintStyle: TextStyle(
                                  color: kPrimaryColor.withOpacity(0.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/images/search.svg"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 50),
            Material(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
              child: InkWell(
                onTap: () => movetoComparePage(context),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  alignment: Alignment.center,
                  //for changing width of login button when changebutton is true
                  width: changeButton ? 50 : 150,
                  height: 50.0,
                  //showing login text or done icon based on changebutton and animating the login button
                  child: changeButton
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : Text(
                          "Compare",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
