import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/add_cloud_or_self_managed.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/userspace_page.dart';
import 'package:panduza_sandbox_flutter/pages/setup_pages/authentification_page.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/broker_connection_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/drawer.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/utils_widgets.dart';

List<String> platformNames = [];

class ConnectionsPage extends StatefulWidget {
  // get every connections existing on the disk

  const ConnectionsPage({
    super.key,
  });

  // BrokerSniffing brokenSniffer = BrokerSniffing();

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {

  // disk data 
  late final SharedPreferences _prefs;
  late final _prefsFuture = SharedPreferences.getInstance().then((v) => _prefs = v);

  // If user is trying to connect to a broker
  bool isConnecting = false;

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
                // Try connecting only if connection has not been tried on another broker
                if (!isConnecting) {
                  isConnecting = true;
                  // If local just permit to user to go on the broker directly
                  tryConnecting(host, port, "", "").then((client) {
                    if (isConnecting) {
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
                          isConnecting = false;
                          client.disconnect();
                        });
                      } else {
                        isConnecting = false;
                        showMyDialogError(context, "Connection to the broker failed");
                      }
                    }
                  });
                }
              }  
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // bar at the top of the application
      appBar: getConnectionsAppBar("Connections", context),
      // Sliding menu 
      drawer: getDrawer(context),

      // The connection buttons who show connections save on the disk
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!(_prefs.containsKey(connectionKey))) {
              return const SizedBox.shrink();
            } else {
              platformNames = _prefs.getStringList(connectionKey) as List<String>;
              return getConnectionsButtonsList(_prefs, platformNames, context, this);
            }
          } 
          // `_prefs` is not ready yet, show loading bar till then.
          return const CircularProgressIndicator(); 
        },
      ),
      // Button to add a connection
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          isConnecting = false;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCloudOrSelfManaged(),
            ),
          );
          setState(() {});
        },
        // foregroundColor: grey,
        backgroundColor: black,
        shape: const CircleBorder(
          eccentricity: 1.0,
        ),
        child: Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }
}
