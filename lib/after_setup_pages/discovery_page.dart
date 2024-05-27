import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'manual_connection_page.dart';


 /*
  This class will go looking for different platform on the network sending 
  broadcast  with UTF-8 format and getting an answer for each platform
*/

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {

  // List ip/port broker of the platforms already discovered
  List<(String, int, String)> platformsIpsPorts = [];
  bool isLoading = false;

  Timer? timer;

  // List socket who has been closed when changing page or refreshing
  List<RawDatagramSocket> sockets = [];

  // List of subscription to realize listen
  List<StreamSubscription<RawSocketEvent>> subscriptions = [];

  // Create socket for each network interface and listen message on them while 
  // page is not refresh
  
  Future<void> platformDiscoveryStart() async {

    // Could have some problem with some android phone ?
    List<NetworkInterface> listInterface = await NetworkInterface.list();
    
    for (NetworkInterface interface in listInterface) {
      for (InternetAddress address in interface.addresses) {
        RawDatagramSocket socket = await RawDatagramSocket.bind(address.address, 63500);
        socket.broadcastEnabled = true;
        // Add to the list of socket to close when changing of page or refreshing 
        sockets.add(socket);
        subscriptions.add(
          socket.listen((event) {
            Datagram? datagram = socket.receive();
            if (datagram != null) {
              String answer = utf8.decode(datagram.data);
          
              Map<String, dynamic> answerMap = jsonDecode(answer);

              Map<String, dynamic>? brokerInfo = answerMap["broker"];
              Map<String, dynamic>? platformInfo = answerMap["platform"];
              
              if (brokerInfo != null && platformInfo != null) {
                String? brokerAddr = brokerInfo["addr"];
                int? brokerPort = brokerInfo["port"];
                String? platformName = platformInfo["name"];

                // if platform name is not given in the answer payload do not add this platform 
                if (platformName != null && brokerAddr != null && brokerPort != null) {
                  
                  // Get addr, port and platform name
                  if (!platformsIpsPorts.contains((datagram.address.address, brokerPort, platformName))) {
                    setState(() {
                      // add the new platform discovered to the list seen by the user, sort them by name
                      platformsIpsPorts.add((datagram.address.address, brokerPort, platformName));
                      platformsIpsPorts.sort(((a, b) => a.$3.compareTo(b.$3)));
                    });
                  }
                }
              } 
            }
          }, onError: (error) {
            print("error: $error");
          }, onDone: () {
            print("done!");
          }, cancelOnError: true)
        );
      }
    }
  }

  // Send request to discover platforms
  void sendDiscoverRequest() {
    for (RawDatagramSocket socket in sockets) {
      try {
        socket.send(utf8.encode(jsonEncode({"search" : true})), InternetAddress("255.255.255.255"), portLocalDiscovery);
      } on SocketException catch(e) {
        print("Local discovery on ${e.address}:${e.port} failed, error code = ${e.osError?.errorCode}, ${e.osError?.message}");
      }
    }
  }


  // List of button of local platform detected 
  Widget localDiscoveryConnections(List<(String, int, String)> platformsIpsPorts, bool isLoading) {

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
                color: black,
              ),
              child: Center(
                child: Column (
                  children: <Widget>[
                    AutoSizeText(
                      platformsIpsPorts[index].$3,
                      style: TextStyle(
                        color: blue
                      ),
                    ),
                    AutoSizeText(
                      platformsIpsPorts[index].$1
                    ),
                    AutoSizeText(
                      platformsIpsPorts[index].$2.toString()
                    )
                  ],
                )
              ),
            ),
            onTap: () {
              // close socket, stop the timer before changing of page
              String platformName = platformsIpsPorts[index].$3;
              String ip = platformsIpsPorts[index].$1;
              String port = platformsIpsPorts[index].$2.toString();
              clearInstance();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ManualConnectionPage(
                    name: platformName,
                    ip: ip,
                    port: port
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

  // Stop listens on socket, close sockets, stop sendings message to platforms 
  // and clear lists
  void clearInstance() {
    for (StreamSubscription<RawSocketEvent> subscription in subscriptions) {
      subscription.cancel();
    }
    for (RawDatagramSocket socket in sockets) {
      socket.close();
    }
    sockets.clear();
    timer?.cancel();
    platformsIpsPorts.clear();
  }

  @override
  void initState() {
    super.initState();
    platformDiscoveryStart();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      sendDiscoverRequest();
    });
  }

  @override dispose() {
    clearInstance();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Local Discovery"),
      body: localDiscoveryConnections(platformsIpsPorts, isLoading),
      bottomSheet: Wrap(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 1.1,
            height: MediaQuery.sizeOf(context).height / 12,
            child: TextButton(
              style: ButtonStyle (
                backgroundColor: MaterialStateProperty.all<Color>(black)
              ),
              onPressed: () {
                // Close sockets then create new ones if potential bugs
                sockets.map((socket) => socket.close());
                sockets.clear();
                platformDiscoveryStart();
              },
              child: Text(
                'REFRESH',
                style: TextStyle(
                  color: white,
                  fontSize: 18
                )
              )
            )
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 1.1,
            height: 20,
          ),
        ],
      ),
    );
  }
}