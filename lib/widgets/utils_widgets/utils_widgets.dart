import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/connections_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/userspace_page.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/edit_page.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';
import 'package:panduza_sandbox_flutter/pages/setup_pages/authentification_page.dart';

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
          platformNames[index],
          style: TextStyle(
            color: blue
          ),
          maxLines: 1,
        ),
        const SizedBox(
          height: 5,
        ),
        AutoSizeText(
          (prefs.getStringList(platformNames[index]) as List<String>)[1],
          maxLines: 1,
        ),
        const SizedBox(
          height: 5,
        ),
        AutoSizeText(
          (prefs.getStringList(platformNames[index]) as List<String>)[2],
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
                  List<String> platformNames = prefs.getStringList(connectionKey) as List<String>;

                  // platformNames.indexOf(element)
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

// Get the layout of button when user has a big screen
Widget getBasicLayoutDynamic(BuildContext context, {required Widget page, required String title, 
    required IconData icon, required String buttonLabel, required String description, required Widget page2, 
    required String title2, required IconData icon2, required String buttonLabel2, 
    required String description2}) {

  double width = 300;
  double height = 300;
  double iconSize = 60;

  if (MediaQuery.sizeOf(context).width > 700 && MediaQuery.sizeOf(context).height > 300) {
    width = 300;
    height = 300;
    iconSize = 120;
  } else {
    width = 250;
    height = 200;
    iconSize = 60;
  }

  if (width == 300 && height == 300 && iconSize == 120) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // get the button to go to the login page of cloud 
          // with info icon to get the information giving details
          // on what the cloud can currently offer 
          getTransitionButton(
            context,
            page,
            // "Panduza Cloud",
            title,
            Icon(
              icon,
              color: white,
              size: 120,
            ),
            buttonLabel,
            description,
            width,
            height,
            titleFontSize: 24,
            descriptionFontSize: 14
          ),
          const SizedBox(
            height: 30
          ),
          // get the button to go to the page to add a self managed
          // broker or if a connection already exist go to the connections page 
          // with a info icon to precise what is a self managed broker 
          getTransitionButton(
            context,
            page2, 
            // "Self-Managed Broker",
            title2,
            Icon(
              icon2,
              color: white,
              size: 120,
            ),
            buttonLabel2,
            description2,
            width,
            height,
            titleFontSize: 24,
            descriptionFontSize: 14
          )
        ],
      ),
    );
  }

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // get the button to go to the login page of cloud 
        // with info icon to get the information giving details
        // on what the cloud can currently offer 
        getTransitionButton(
          context,
          page,
          // "Panduza Cloud",
          title,
          Icon(
            icon,
            color: white,
            size: 60,
          ),
          buttonLabel,
          description,
          width,
          height,
          titleFontSize: 18,
          descriptionFontSize: 12
        ),
        const SizedBox(
          height: 30
        ),
        // get the button to go to the page to add a self managed
        // broker or if a connection already exist go to the connections page 
        // with a info icon to precise what is a self managed broker 
        getTransitionButton(
          context,
          page2, 
          // "Self-Managed Broker",
          title2,
          Icon(
            icon2,
            color: white,
            size: 60,
          ),
          buttonLabel2,
          description2,
          width,
          height,
          titleFontSize: 18,
          descriptionFontSize: 12
        )
      ],
    ),
  );
}

// Button to go to another page 
Widget getTransitionButton(BuildContext context, Widget page, String title, Icon icon,
    String buttonLabel, String description, double width, double height, {
      double titleFontSize = 24, double descriptionFontSize = 14
    }) {
  return Container (
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: black,
      borderRadius: const BorderRadius.all(
        Radius.circular(12)
      )
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 20
            ),
            Text(
              // "Self-Managed Broker",
              title,
              style: TextStyle(
                fontSize: titleFontSize,
                color: white
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        icon,
        AutoSizeText(
          description,
          style: TextStyle(
            fontSize: descriptionFontSize,
            color: white
          ),
          maxLines: 1,
        ),
        const SizedBox(
          height: 15,
        ),
        FilledButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => page)
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(blue)
          ),
          child: Text(
            // 'Append',
            buttonLabel,
            style: TextStyle(
              color: black
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

// Basic visual of a text field
Widget getSimpleTextField(BuildContext context, TextEditingController ctrl, 
    String label) {
  return TextField(
    controller: ctrl,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.labelSmall,
      // Color or the container underline when not field not 
      // tap
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: white
        )
      ),
      // Color or the container underline when field has been tap
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: blue
        )
      ),
    ),
    style: Theme.of(context).textTheme.displayMedium
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
                        brokerConnectionInfo: BrokerConnectionInfo(
                          host, 
                          int.parse(port), 
                          client
                        ),
                      )
                    ),
                  ).then((value) {
                    client.disconnect();
                  });
                } else {
                  showMyDialogError(context, "Connection to the broker failed");
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

