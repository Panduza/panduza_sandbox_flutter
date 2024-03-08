import 'package:flutter/material.dart';

import '../data/const.dart';

// Page who will discover the differents platforms on 
// the network

final List<String> brokers = ["Broker 1", "Broker 2", "Broker 3"];
final List<String> ips = ["192.168.1.33", "192.168.1.32", "192.168.1.31"];
final List<String> ports = ["1885", "1884", "1883"];

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {

  @override
  Widget build(BuildContext context) {
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

      // mqtt form
      /*
      body: const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[MqttConnectionForm()],
        ),
      ),      
      */
      body: ListView.separated(
        padding: const EdgeInsets.all(40),
        itemCount: 3,
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
                      Text(
                        '${ips[index]}',
                        style: TextStyle(
                          color: white
                        ),
                      ),
                      Text(
                        '${ports[index]}',
                        style: TextStyle(
                          color: white
                        ),
                      )
                    ],
                  )
                ),
              )
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}