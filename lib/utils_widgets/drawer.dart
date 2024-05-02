import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/add_cloud_or_self_managed.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/setup_pages/authentification_page.dart';

// Drawer show on the home page (connections page)

Widget getDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: white,
    child: Column(
      children: [
        // Need to change logo to pass to the new final version
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
        // Send on the page who give the choice between use cloud 
        // or add a self managed broker 
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border (
              top: BorderSide(
                color: black
              ),
            ),
          ),
          child: TextButton(
            child: Text(
              "Add Connections",
              style: TextStyle(
                color: black
              ),
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const AddCloudOrSelfManaged())
              );
            },
          ),
        ),
        // Send on the page who give directly access to the authentification page in the cloud 
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
              "Cloud",
              style: TextStyle(
                color: black
              ),
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const AuthentificationPage(
                  hostIp: "",
                  port: ""
                ))
              );
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