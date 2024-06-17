import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/add_cloud_or_self_managed.dart';
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
