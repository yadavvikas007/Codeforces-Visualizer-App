import 'package:codeforces_visualizer/components/appbar.dart';
import 'package:codeforces_visualizer/components/uiElements.dart';
import 'package:codeforces_visualizer/screens/drawer.dart';
import 'package:codeforces_visualizer/screens/singleUserDetailsPage.dart';
import 'package:codeforces_visualizer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SingleUserInputPage extends StatefulWidget {
  const SingleUserInputPage({Key? key}) : super(key: key);
  @override
  _SingleUserInputPageState createState() => _SingleUserInputPageState();
}

class _SingleUserInputPageState extends State<SingleUserInputPage> {
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
  //user handle
  String _handle = "";

  //to check for valid user handle
  bool isValid = false;

  //form key
  final _formKey = GlobalKey<FormState>();

  //for compare button animation
  bool changeButton = false;

  //validating entered user handle
  validateUser() async {
    var url =
        Uri.https("www.codeforces.com", "/api/user.info?handles=$_handle");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse["result"].isEmpty) {
        isValid = false;
      } else {
        isValid = true;
      }
    }
  }

  movetoDetailsPage(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      //validate current entries
      setState(() {
        changeButton = true;
      });
      //ab 1 sec to dena pdega na button animation dikhane k liye
      await Future.delayed(Duration(seconds: 1));
      //moving to details page
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              SingleUserDetailsPage(handle: _handle),
        ),
        ModalRoute.withName("/"),
      );
      //reseting the data here before moving to next page
      setState(() {
        _handle = "";
        isValid = false;
        changeButton =
            false; //for if we move back to login page , the login page is resetted
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
              height: size.height * 0.2,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  emptySpace(size.height * 0.2 - 27),
                  Positioned(
                    bottom: 35,
                    left: 10,
                    right: 10,
                    child: codeforcesLogo(size),
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
                                _handle = value;
                                validateUser();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Username cannot be empty";
                                } else if (!isValid) {
                                  return "Invalid Username";
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.grey[900]),
                              decoration: InputDecoration(
                                hintText: "Search User",
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
                onTap: () {
                  movetoDetailsPage(context);
                },
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
                          "Search",
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
