import 'package:auto_size_text/auto_size_text.dart';
import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/pages/setup_pages/cloud_config_auth_page.dart';

// bar at the top of the application on nearly every page

PreferredSizeWidget? getAppBar(String title) {
  return AppBar(
    // color of hamburger button
    iconTheme: IconThemeData(color: white),
    backgroundColor: black,
    title: AutoSizeText(
      title,
      style: TextStyle(
        color: blue,
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Image.asset('assets/logo_circle_black_blue_1024.png'),
        iconSize: 50,
        onPressed: () {
          return;
        }, 
      )
    ],
  );
}

// app bar for users space page 
PreferredSizeWidget? getAppBarUserSpace(String title, BuildContext context) {
  return AppBar(
    // color of hamburger button
    iconTheme: IconThemeData(color: white),
    backgroundColor: black,
    title: AutoSizeText(
      title,
      style: TextStyle(
        color: blue,
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Image.asset('assets/logo_circle_black_blue_1024.png'),
        iconSize: 50,
        onPressed: () {
          return;
        }, 
      )
    ],
    leading: BackButton(
      color: white,
      onPressed: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionsPage()));
        Navigator.pop(context);
      },
    ),
  );
}

// app bar for users space page 
PreferredSizeWidget? getConnectionsAppBar(String title, BuildContext context) {
  return AppBar(
    // color of hamburger button
    iconTheme: IconThemeData(color: white),
    backgroundColor: black,
    title: AutoSizeText(
      title,
      style: TextStyle(
        color: blue,
      ),
    ),
    actions: <Widget>[
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CloudAuthPage())
          );
        }, 
        icon: Icon(
          Icons.cloud_outlined,
          color: blue,
        ),
      ),
      IconButton(
        icon: Image.asset('assets/logo_circle_black_blue_1024.png'),
        iconSize: 50,
        onPressed: () {
          return;
        }, 
      )
    ]
  );
}