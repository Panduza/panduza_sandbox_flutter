import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/pages/edit_page.dart';
import 'package:panduza_sandbox_flutter/pages/home_page.dart';
import 'package:panduza_sandbox_flutter/pages/manual_connection_page.dart';
import 'package:panduza_sandbox_flutter/pages/first_user_creation_page.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';
import 'package:panduza_sandbox_flutter/pages/authentification_page.dart';

// on the home page content of each connection button 
// displaying the name, the host ip and the port 

Widget getConnectionButton(SharedPreferences prefs, List<String> platformNames, 
    int index) {

  return Expanded(
    child: Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Think to try changing in auto ajust text
        AutoSizeText(
          '${platformNames[index]}',
          style: TextStyle(
            color: blue
          ),
          maxLines: 1,
        ),
        const SizedBox(
          height: 5,
        ),
        AutoSizeText(
          '${(prefs.getStringList(platformNames[index]) as List<String>)[1]}',
          style: TextStyle(
            color: white
          ),
          maxLines: 1,
        ),
        const SizedBox(
          height: 5,
        ),
        AutoSizeText(
          '${(prefs.getStringList(platformNames[index]) as List<String>)[2]}',
          style: TextStyle(
            color: white
          ),
          maxLines: 1,
        )
      ],
    ),
  );
}


// Icon to edit a connection on the home page

Widget getEditConnectionButton(SharedPreferences prefs, List<String> platformNames,
    int index, BuildContext context, State<HomePage> state){
  return IconButton(
    onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPage(
                    platformName: platformNames[index], 
                    hostIp: (prefs.getStringList(platformNames[index]) as List<String>)[1], 
                    port: (prefs.getStringList(platformNames[index]) as List<String>)[2]
          ),
        )
      );
      state.setState(() {});;
    }, 
    icon: const Icon(
      Icons.edit,
      color: Colors.white,
      size: 20,
    ),
    alignment: Alignment.centerRight,
  );
}


// Icon to delete a connection save on the disk 
// (on the home page)

Widget getDeleteConnectionButton(SharedPreferences prefs, List<String> platformNames,
    int index, BuildContext context, State<HomePage> state) {
  return IconButton(
    onPressed: () {
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure ?'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Yes'),
                onPressed: () {
                  // remove the connection of disk, 
                  // first the direct entry of this connection 
                  // then remove it from the directory (connectionKey)
                  // if there no more connection remove the entry of the
                  // directory (connectionKey)

                  prefs.remove(platformNames[index]);

                  platformNames.remove(platformNames[index]);
                  prefs.setStringList(connectionKey, platformNames);

                  if (platformNames.isEmpty) prefs.remove(connectionKey);
                  state.setState(() {});
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    }, 
    icon: const Icon(
      Icons.delete,
      color: Colors.white,
      size: 20,
    ),
    alignment: Alignment.centerRight,
  );
}

// Connection list display on the home page load from the disk

Widget getConnectionsButtonsList(SharedPreferences prefs, List<String> platformNames,
    BuildContext context, State<HomePage> state) {
  return ListView.separated(
    padding: const EdgeInsets.all(20),
    itemCount: platformNames.length,
    itemBuilder: (BuildContext context, int index) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: grey,
            ),
            child: Row (
              children: <Widget>[
                getConnectionButton(prefs, platformNames, index),
                Column(
                  children: [
                    getEditConnectionButton(prefs, platformNames, index, context, state),
                    getDeleteConnectionButton(prefs, platformNames, index, context, state)
                  ],
                ),
              ] 
            )
          ),
          // If the user click on a connection, it will try to connect 
          // to the mqtt broker if it fail then a small banner will appear
          // else he will be redirect on the userpage corresponding
          onTap: () {
            String host = (prefs.getStringList(platformNames[index]) as List<String>)[1];
            String port = (prefs.getStringList(platformNames[index]) as List<String>)[2];

            // check if first account has been created, if it's true then go to the authentification
            // page else go to the page of creation of the first admin account
            firstAccountExist().then((response) {
              bool fistAccountExist = json.decode(response.body)["first_account_exist"];

              if (fistAccountExist) {
                // Go to authentification page with connection information of the broker
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthentificationPage(
                      hostIp: host, 
                      port: port
                    )
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirstUserCreationPage(
                      hostIp: host, 
                      port: port
                    )
                  ),
                );
              }
            });
          },
        ),
      );
    },
    separatorBuilder: (context, index) => const Divider(),
  );
}


// Button list of connection in the local discovery page

Widget localDiscoveryConnections(List<(InternetAddress, int)> platformsIpsPorts, bool isLoading) {

  if (isLoading) {
    return Center(
      child: CircularProgressIndicator(
        color: blue,
      )
    );
  } 

  return ListView.separated(
    padding: const EdgeInsets.all(40),
    itemCount: platformsIpsPorts.length,
    itemBuilder: (BuildContext context, int index) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: grey,
            ),
            child: Center(
              
              child: Column (
                children: <Widget>[
                  AutoSizeText(
                    // '${platformsIpsPorts[index].$1.host}',
                    "local",
                    style: TextStyle(
                      color: blue
                    ),
                  ),
                  AutoSizeText(
                    '${platformsIpsPorts[index].$1.address}',
                    style: TextStyle(
                      color: white
                    ),
                  ),
                  AutoSizeText(
                    '1883',
                    style: TextStyle(
                      color: white
                    ),
                  )
                ],
              )
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManualConnectionPage(
                  ip: platformsIpsPorts[index].$1.address,
                  port: "1883"
                ),
              ),
            );
          },
        ),
      );
    },
    separatorBuilder: (context, index) => const Divider(),
  );
}
