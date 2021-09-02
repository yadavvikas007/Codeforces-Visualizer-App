import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

AppBar buildAppBar() {
  return AppBar(
    elevation: 0.0,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: SvgPicture.asset("assets/images/menu.svg"),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
  );
}
