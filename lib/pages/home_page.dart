import 'package:flutter/material.dart';
// import 'package:panduza_sandbox_flutter/data/broker_sniffing.dart';
import '../data/broker_sniffing.dart';

import '../data/const.dart';
import 'home/mqtt_connection_form.dart';

// final List<String> equipments = ["LASER", "ROBOT O", "Quantique"];
final List<String> brokers = ["Broker 1", "Broker 2", "Broker 3"];
final List<String> ips = ["192.168.1.33", "192.168.1.32", "192.168.1.31"];
final List<String> ports = ["1885", "1884", "1883"];

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  // BrokerSniffing brokenSniffer = BrokerSniffing();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        title: Text(
          widget.title,
          style: TextStyle(
            color: blue,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('../../assets/icons/logo_1024.png'),
            iconSize: 50,
            onPressed: () {
              return;
            }, 
          )
        ],
      ),
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
              /*
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondRoute()),
                );
              },*/
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
                        '${brokers[index]}',
                        style: TextStyle(
                          color: blue
                        ),
                      ),
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
