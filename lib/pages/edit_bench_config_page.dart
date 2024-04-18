import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/pages/add_bench_to_config_page.dart';
import 'package:panduza_sandbox_flutter/pages/edit_device_config_page.dart';

class EditBenchConfigPage extends StatefulWidget {

  EditBenchConfigPage({super.key, required this.token});

  final String token;
  dynamic benchs;

  @override
  State<EditBenchConfigPage> createState() => _EditBenchConfigPageState();
}

class _EditBenchConfigPageState extends State<EditBenchConfigPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Benchs"),

      // Make a request to get every bench registered in the 
      // config bdd 
      body: FutureBuilder(
        future: getBench(widget.token),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> responseObject = json.decode(snapshot.data!.body);
            widget.benchs = responseObject["bench"];
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: widget.benchs.length,
              itemBuilder: (BuildContext context, int index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: grey,
                      ),
                      child: Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.benchs[index]["name"],
                            style: TextStyle(
                              color: white
                            ),
                          )
                        ]
                      )
                    ),
                    // If the user click on this bench it will send him on a page with 
                    // different devices connected to this bench 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDeviceConfig(
                            token: widget.token,
                            benchInfo: widget.benchs[index]
                          ),
                        ),
                      ).then((bench) {
                        // add the new device to the correct bench
                        
                      });
                    }
                  ));
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          }
          // `_prefs` is not ready yet, show loading bar till then.
          return const CircularProgressIndicator(); 
        },
      ),
      
      // Button to add a connection
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBenchToConfigPage(
                token: widget.token
              ),
            ),
          ).then((newBenchs) {
            widget.benchs = newBenchs;
          });
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
