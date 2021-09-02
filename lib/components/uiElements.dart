import 'package:codeforces_visualizer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget emptySpace(double height) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(36),
        bottomRight: Radius.circular(36),
      ),
    ),
  );
}

Widget codeforcesLogo(Size size) {
  return SvgPicture.asset(
    "assets/images/code-forces (1).svg",
    width: size.width / 3,
    height: size.height / 7,
  );
}

Widget codeforcesNamedLogo() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: kPadding),
    height: 54,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 10),
          blurRadius: 50,
          color: kPrimaryColor.withOpacity(0.30),
        )
      ],
    ),
    child: Center(
      child: Image.asset(
        "assets/images/cflogo.png",
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}
