import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/pages/add_device_to_bench_page.dart';

class EditDeviceConfig extends StatefulWidget {

  const EditDeviceConfig({super.key, required this.token, required this.benchInfo});

  final String token;
  final Map<String,dynamic> benchInfo;

  @override
  State<EditDeviceConfig> createState() => _EditDeviceConfigState();
}

class _EditDeviceConfigState extends State<EditDeviceConfig> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Devices"),

      // get devices of a bench, for the moment will go bench  

      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: widget.benchInfo["devices"].length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: grey,
            ),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.benchInfo["devices"][index]["name"],
                  style: TextStyle(
                    color: white
                  ),
                )
              ]
            )
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      
      // Button to add a connection
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDeviceToBenchPage(
                token: widget.token,
                benchId: widget.benchInfo["id"],
              ),
            ),
          );
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
