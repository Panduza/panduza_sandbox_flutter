import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/add_cloud_or_self_managed.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/pages/setup_pages/authentification_page.dart';

// Drawer show on the home page (connections page)

Widget getDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: white,
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          width: 200,
          child: IconButton(
            icon: Image.asset('assets/logo_circle_black_blue_1024.png'),
            onPressed: () {
              return;
            }, 
          ),
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