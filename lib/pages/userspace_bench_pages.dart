import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'dart:convert';

import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/pages/add_bench_page.dart';
import 'package:panduza_sandbox_flutter/pages/userspace_devices_page.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';

// Page who display the different bench registered on the broker, you can 
// add a new bench or go watch the current visible devices of these devices 
// pressing one of them

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

  // Map who associate a bench to different devices with differents interfaces
  Map<String, Map<String, List<InterfaceConnection>>> deviceToInterfaces = {}; 

  Timer? timer;

  // load the mqtt topics of the broker mqtt 

  Future<void> loadTopics() async {

    widget.brokerConnectionInfo.client
          .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString('*');
    final payload = builder.payload;
    widget.brokerConnectionInfo.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);

      // Run your async function here
      // await myAsyncFunction();

    widget.brokerConnectionInfo.client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {

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

        
        if (!interfaceAlreadyRegistered(ic, interfaces)) {
          if (ic.getType() != "device") {
            interfaces = [...interfaces, ic];
          }
        }
        
        if (!deviceToInterfaces.containsKey(ic.getBenchName())) {
          deviceToInterfaces[ic.getBenchName()] = {ic.getDeviceName() : [ic]};
        } else {
          // We are sure there is a element to the index of this benchName
          var interfaces = deviceToInterfaces[ic.getBenchName()] as Map<String, List<InterfaceConnection>>;
          if (!interfaces.containsKey(ic.getDeviceName())) {
            // The interfaceList cannot in normal case be null
            
            interfaces[ic.getDeviceName()] = [ic];
          } else {

            List<InterfaceConnection>? interfaceList = interfaces[ic.getDeviceName()];

            if (interfaceList != null) {
              if (!interfaceList.contains(ic)) {
                interfaceList.add(ic);
                interfaceList.sort((a, b) {
                  return a.getType().compareTo(b.getType());
                });

                var tmpMap = deviceToInterfaces[ic.getBenchName()];
                
                if (tmpMap != null) {
                  tmpMap[ic.getDeviceName()] = interfaceList;
                  (tmpMap[ic.getDeviceName()] as List<InterfaceConnection>).sort((a, b) {
                    return a.getType().compareTo(b.getType());
                  });
                  
                  deviceToInterfaces[ic.getBenchName()] = tmpMap;
                }
              }
            }
          }
        }

        // Get a list for the benchs 
        if(!platformAlreadyRegistered(ic.getBenchName(), benchList)) {
          benchList.add(ic.getBenchName());
          benchList.sort();
          // setState(() {});
        } 
      }
    });
  }

  @override
  void initState() {
    super.initState();

    loadTopics().then((value) {
      setState(() {});
    });

    // Here it would be better to setState only when the map became different

    timer = Timer.periodic(
      const Duration(seconds: 1), (Timer t) {
        setState(() {});
      }
    );
  }
  
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Page who display the different bench registered on the broker, you can 
  // add a new bench or go watch the current visible devices of these devices 
  // pressing one of them
  
  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;
    final int columns = (width / 300.0).round();

    return Scaffold(
      appBar: getAppBar("Benches"),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Ink(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: white
                )
              )
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  UserspaceDevicesPage(
                      brokerConnectionInfo: widget.brokerConnectionInfo,
                      listInterfaceConnection: interfaces,
                      benchName: benchList[index],
                      deviceToInterfaces: deviceToInterfaces[benchList[index]] as Map<String, List<InterfaceConnection>>,
                      // deviceToInterfaces: deviceToInterfaces,
                    ),
                  ),
                );
              },
              child: Center(
                child: Text(
                  benchList[index],
                  style: TextStyle(
                    color: white
                  ),
                ),  
              ),
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
              builder: (context) => const AddBenchPage(),
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
