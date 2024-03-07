import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/utils_widgets/drawer.dart';
// import 'package:panduza_sandbox_flutter/data/broker_sniffing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'userspace_page.dart';
import '../data/const.dart';
import '../data/broker_sniffing.dart';
import 'package:panduza_sandbox_flutter/pages/add_connection_page.dart';
import 'home/mqtt_connection_form.dart';
import '../data/const.dart';
import '../data/utils.dart';
import '../pages/edit_page.dart';

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
      appBar: AppBar(
        // color of hamburger button
        iconTheme: IconThemeData(color: white),
        backgroundColor: black,
        title: Text(
          // widget.title,
          "Connections",
          style: TextStyle(
            color: blue,
          ),
        ),
        // Panduza logo
        // TO DO : Change to logo2 
        actions: <Widget>[
          IconButton(
            icon: Image.asset('../../assets/icons/logo_1024.png'),
            /*            
            icon: SvgPicture.asset(
              '../../assets/icons/logo2.svg'
            ),
            */
            iconSize: 50,
            onPressed: () {
              return;
            }, 
          )
        ],
      ),
      // Sliding menu 
      drawer: getDrawer(),
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!(_prefs.containsKey(connectionKey))) {
              return const SizedBox.shrink();
            } else {
              platformNames = _prefs.getStringList(connectionKey) as List<String>;
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: platformNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      /*
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SecondRoute()),
                        );
                      },*/
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey,
                        ),
                        child: Row (
                          children: <Widget>[
                            Expanded(
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
                                    '${(_prefs.getStringList(platformNames[index]) as List<String>)[1]}',
                                    style: TextStyle(
                                      color: white
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  AutoSizeText(
                                    '${(_prefs.getStringList(platformNames[index]) as List<String>)[2]}',
                                    style: TextStyle(
                                      color: white
                                    ),
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            ), 
                            Column(
                              children: [
                                // Icon to edit a connection
                                IconButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPage(
                                                  platformName: platformNames[index], 
                                                  hostIp: (_prefs.getStringList(platformNames[index]) as List<String>)[1], 
                                                  port: (_prefs.getStringList(platformNames[index]) as List<String>)[2]
                                        ),
                                      )
                                    );
                                    setState(() {});
                                  }, 
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                                // Icon to delete a connection
                                IconButton(
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

                                                _prefs.remove(platformNames[index]);

                                                platformNames.remove(platformNames[index]);
                                                _prefs.setStringList(connectionKey, platformNames);

                                                if (platformNames.isEmpty) _prefs.remove(connectionKey);
                                                setState(() {});
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
                                )
                              ],
                            ),
                          ] 
                        )
                      ),
                      // If the user click on a connection, it will try to connect 
                      // to the mqtt broker if it fail then a small banner will appear
                      // else he will be redirect on the userpage corresponding
                      onTap: () {
                        String host = (_prefs.getStringList(platformNames[index]) as List<String>)[1];
                        String port = (_prefs.getStringList(platformNames[index]) as List<String>)[2];
                        tryConnecting(host, port).then((client) {
                          if (client != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserspacePage(
                                      broker_connection_info: BrokerConnectionInfo(
                                          host, 
                                          int.parse(port), 
                                          client),
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
          } 
          // `_prefs` is not ready yet, show loading bar till then.
          return CircularProgressIndicator(); 
        },
      ),
      
      // Button to add connection
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
