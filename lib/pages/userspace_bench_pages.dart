import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/ic_blc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_bpc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_platform.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_not_managed.dart';

// import '../widgets/interface_control/icw_bpc.dart';

import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/pages/add_bench_page.dart';
import 'package:panduza_sandbox_flutter/pages/userspace_devices_page.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';

class UserspaceBenchPage extends StatefulWidget {
  const UserspaceBenchPage({super.key, required this.brokerConnectionInfo});

  final BrokerConnectionInfo brokerConnectionInfo;

  @override
   State<UserspaceBenchPage> createState() => _UserspaceBenchPageState();
}

class _UserspaceBenchPageState extends State<UserspaceBenchPage> {

  // The list of every bench test on the broker
  List<String> benchList = [];
  List<InterfaceConnection> interfaces = [];

  // Map who associate a device to different interfaces
  final Map<String, List<InterfaceConnection>> deviceToInterfaces = {}; 

  bool interfaceAlreadyRegistered(InterfaceConnection ic) {
    for (var interface in interfaces) {
      if (interface.topic == ic.topic) {
        return true;
      }
    }
    // print(ic.topic);
    return false;
  }

  bool platformAlreadyRegistered(String benchTest) {
    for (var bench in benchList) {
      if (bench == benchTest) {
        return true;
      }
    }
    // print(ic.topic);
    return false;
  }

  InterfaceConnection? findPlatform() {

    for (var interface in interfaces) {
      if (interface.info["type"] == "platform") {
        return interface;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    widget.brokerConnectionInfo.client
          .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString('*');
    final payload = builder.payload;
    widget.brokerConnectionInfo.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);

    Future.delayed(Duration(milliseconds: 100), () async {
      // Run your async function here
      // await myAsyncFunction();

      widget.brokerConnectionInfo.client.updates!
          .listen((List<MqttReceivedMessage<MqttMessage>> c) {
        // final MqttMessage message = c[0].payload;

        // print('Received  from userspace from topic: ${c[0].topic}>');

        // final string = binascii.b2a_base64(bytearray(data)).decode('utf-8');
        // print(message.toString());

        // pza/*/atts/info

        if (c![0].topic.startsWith("pza") & c![0].topic.endsWith("atts/info")) {
          final recMess = c![0].payload as MqttPublishMessage;

          var topic = c![0]
              .topic
              .substring(0, c![0].topic.length - "/atts/info".length);

          final pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          var jsonObject = json.decode(pt);

          InterfaceConnection ic = InterfaceConnection(
            widget.brokerConnectionInfo.client, topic, jsonObject["info"]
          );

          
          if (!interfaceAlreadyRegistered(ic)) {
            if (ic.getType() != "device") {
              setState(() {
                interfaces = [...interfaces, ic];
              });
            }
          }
          
          

          // if device not registered add a new list of interfaces connected to it
          if (!deviceToInterfaces.containsKey(ic.getDeviceName())) {
            deviceToInterfaces[ic.getDeviceName()] = [ic];
          } else {
            // The interfaceList cannot in normal case be null
            List<InterfaceConnection>? interfaceList = deviceToInterfaces[ic.getDeviceName()];
            if (interfaceList != null) {
              interfaceList.add(ic);
              deviceToInterfaces[ic.getDeviceName()] = interfaceList;
            }
          }

          // Get a list for the benchs 
          if(!platformAlreadyRegistered(ic.getBenchName())) {
            benchList.add(ic.getBenchName());
            setState(() {});
          } 
        }
        // final payload =
        // MqttPublishPayload.bytesToStringAsString(message.);

        // print('Received message:$payload from topic: ${c[0].topic}>');

        // sort and put in my map
        
        
      });
    });
  }
  

  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;
    final int columns = (width / 300.0).round();

    return Scaffold(
      appBar: getAppBar("Benches"),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: white
                    )
                  )
                ),
                child: Center(
                  child: Text(
                    benchList[index],
                    style: TextStyle(
                      color: white
                    ),
                  ),  
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  UserspaceDevicesPage(
                      brokerConnectionInfo: widget.brokerConnectionInfo,
                      listInterfaceConnection: interfaces,
                      benchName: benchList[index]
                    ),
                  ),
                );
              },
            ),
          );
        }, 
        itemCount: benchList.length
      ),
      
      // Button to add a bench
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBenchPage(),
            ),
          );
          setState(() {});
        },
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
