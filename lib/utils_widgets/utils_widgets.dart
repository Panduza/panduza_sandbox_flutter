import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/connections_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/userspace_page.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/edit_page.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/manual_connection_page.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';
import 'package:panduza_sandbox_flutter/setup_pages/authentification_page.dart';

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
          maxLines: 1,
        ),
        const SizedBox(
          height: 5,
        ),
        AutoSizeText(
          '${(prefs.getStringList(platformNames[index]) as List<String>)[2]}',
          maxLines: 1,
        )
      ],
    ),
  );
}


// Icon to edit a connection on the home page

Widget getEditConnectionButton(SharedPreferences prefs, List<String> platformNames,
    int index, BuildContext context, State<ConnectionsPage> state){
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
    int index, BuildContext context, State<ConnectionsPage> state) {
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

Widget getCloudOrLocalIcon(String isCloud) {
  if (isCloud == "1") {
    return const Icon(
      Icons.cloud,
      color: Colors.white,
    );
  }
  return const Icon(
    Icons.home,
    color: Colors.white,
  );
}

// Connection list display on the home page load from the disk

Widget getConnectionsButtonsList(SharedPreferences prefs, List<String> platformNames,
    BuildContext context, State<ConnectionsPage> state) {
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
              color: black,
            ),
            child: Row (
              children: <Widget>[
                getCloudOrLocalIcon((prefs.getStringList(platformNames[index]) as List<String>)[3]),
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

            // Here check if it's local or cloud connection
            String isCloud = (prefs.getStringList(platformNames[index]) as List<String>)[3];

            if (isCloud == "1") {
              // authentification page in the cloud 
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
              // If local just permit to user to go on the broker directly
              tryConnecting(host, port, "", "").then((client) {
                if (client != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserspacePage(
                        broker_connection_info: BrokerConnectionInfo(
                          host, 
                          int.parse(port), 
                          client
                        ),
                      )
                    ),
                  ).then((value) {
                    client.disconnect();
                  });
                }
              });
            }
          },
        ),
      );
    },
    separatorBuilder: (context, index) => const Divider(),
  );
}

