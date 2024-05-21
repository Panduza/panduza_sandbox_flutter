import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'manual_connection_page.dart';


// Page who will discover the differents platforms on 
// the network

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {

  List<(String, int, String)> platformsIpsPorts = [];
  bool isLoading = false;

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ManualConnectionPage(
                    name: platformsIpsPorts[index].$3,
                    ip: platformsIpsPorts[index].$1,
                    port: platformsIpsPorts[index].$2.toString()
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


  @override
  void initState() {
    super.initState();
    platformDiscovery().then(
      (value) {
        platformsIpsPorts = value;
        platformsIpsPorts.sort((a, b) => a.$3.compareTo(b.$3));
        setState(() {});
      }
    );
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
                // Resend a broadcast to detect every local plaform (get 
                // id and for each of them)
                platformDiscovery().then(
                  (value) {
                    platformsIpsPorts = value;
                    platformsIpsPorts.sort((a, b) => a.$3.compareTo(b.$3));
                    setState(() {});
                  }
                );
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