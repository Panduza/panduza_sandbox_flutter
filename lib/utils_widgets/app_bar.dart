import 'dart:io';
import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';

// bar at the top of the application

PreferredSizeWidget? getAppBar(String title) {
  return AppBar(
    // color of hamburger button
    iconTheme: IconThemeData(color: white),
    backgroundColor: black,
    title: Text(
      title,
      style: TextStyle(
        color: blue,
      ),
    ),
    // Panduza logo
    // TO DO : Change to logo2 
    actions: <Widget>[
      IconButton(
        icon: Image.asset('assets/logo_1024.png'),
        /*            
        icon: SvgPicture.asset(
          '../../assets/icons/logo2.svg'
        ),
        */
        iconSize: 50,
        onPressed: () {
          return;
        }, 
      )
    ],
  );
}