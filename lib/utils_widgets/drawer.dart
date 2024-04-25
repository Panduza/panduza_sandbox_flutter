import 'dart:io';
import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';

Widget getDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: white,
    child: Column(
      children: [
        IconButton(
          icon: Image.asset('assets/logo_1024.png'),
          /*            
          icon: SvgPicture.asset(
            '../../assets/icons/logo2.svg'
          ),
          */
          iconSize: 10,
          onPressed: () {
            return;
          }, 
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: black
              ),
            ),
          ),
          child: TextButton(
            child: Text(
              "Connections",
              style: TextStyle(
                color: black
              ),
            ),
            onPressed: () {

            },
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border (
              bottom: BorderSide(
                color: black
              ),
            ),
          ),
          child: TextButton(
            child: Text(
              "Settings",
              style: TextStyle(
                color: black
              ),
            ),
            onPressed: () {

            },
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border (
              bottom: BorderSide(
                color: black
              ),
            ),
          ),
          child: TextButton(
            child: Text(
              "About",
              style: TextStyle(
                color: black
              ),
            ),
            onPressed: () {

            },
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border (
              bottom: BorderSide(
                color: black
              ),
            ),
          ),
          child: TextButton(
            child: Text(
              "Exit",
              style: TextStyle(
                color: black
              ),
            ),
            onPressed: () {
              exit(0);
            },
          ),
        ),
      ],
    ),
  );
}