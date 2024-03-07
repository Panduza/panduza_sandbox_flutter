import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../data/const.dart';

Widget getDrawer() {
  return Drawer(
    backgroundColor: white,
    child: Column(
      children: [
        IconButton(
          icon: Image.asset('../../assets/icons/logo_1024.png'),
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
        Container(
          child: const Text(
            "Connections"
          ),
        ),
        Container(
          child: const Text(
            "Settings"
          ),
        ),
        Container(
          child: const Text(
            "About"
          ),
        ),
        Container(
          child: const Text(
            "Exit"
          ),
        ),
      ],
    ),
  );
}