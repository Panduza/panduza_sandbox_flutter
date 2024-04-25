import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/pages/add_connection_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/drawer.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';

// final List<String> equipments = ["LASER", "ROBOT O", "Quantique"];
// final List<String> brokers = ["Broker 1", "Broker 2", "Broker 3"];
// final List<String> ips = ["192.168.1.33", "192.168.1.32", "192.168.1.31"];
// final List<String> ports = ["1885", "1884", "1883"];

List<String> platformNames = [];
List<String> ips = [];
List<String> ports = [];

class HomePage extends StatefulWidget {
  // get every connections existing on the disk

  const HomePage({super.key, required this.title});

  final String title;

  // BrokerSniffing brokenSniffer = BrokerSniffing();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final SharedPreferences _prefs;
  late final _prefsFuture = SharedPreferences.getInstance().then((v) => _prefs = v);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Connections"),
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
              builder: (context) => const AddConnectionPage(),
            ),
          );
          setState(() {});
        },
        // foregroundColor: grey,
        backgroundColor: grey,
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
