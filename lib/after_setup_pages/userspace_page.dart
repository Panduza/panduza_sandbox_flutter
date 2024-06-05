import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/ic_blc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_bpc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_platform.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_not_managed.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_video.dart';

// import '../widgets/interface_control/icw_bpc.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_relay.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';

class UserspacePage extends StatefulWidget {
  const UserspacePage({super.key, required this.broker_connection_info});

  final BrokerConnectionInfo broker_connection_info;

  @override
  State<UserspacePage> createState() => _UserspacePageState();
}

class _UserspacePageState extends State<UserspacePage> {
  List<InterfaceConnection> interfaces = [];
  Map<int, InterfaceConnection> channel = {}; 


  bool interfaceAlreadyRegistered(InterfaceConnection ic) {
    for (var interface in interfaces) {
      if (interface.topic == ic.topic) {
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

    widget.broker_connection_info.client
          .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString('*');
    final payload = builder.payload;
    widget.broker_connection_info.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);

    Future.delayed(Duration(milliseconds: 1), () async {
      // Run your async function here
      // await myAsyncFunction();

      widget.broker_connection_info.client.updates!
          .listen((List<MqttReceivedMessage<MqttMessage>> c) {
        // final MqttMessage message = c[0].payload;

        // print('Received  from userspace from topic: ${c[0].topic}>');

        // final string = binascii.b2a_base64(bytearray(data)).decode('utf-8');
        // print(message.toString());

        // pza/*/atts/info
        // print(c![0].topic);
        if (c![0].topic.startsWith("pza") & c![0].topic.endsWith("atts/info")) {
          final recMess = c![0].payload as MqttPublishMessage;

          var topic = c![0]
              .topic
              .substring(0, c![0].topic.length - "/atts/info".length);

          final pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          var jsonObject = json.decode(pt);

          // print(jsonObject);

          InterfaceConnection ic = InterfaceConnection(
              widget.broker_connection_info.client, topic, jsonObject["info"]);
          
          if (!interfaceAlreadyRegistered(ic)) {
            if (ic.getType() != "device") {
              setState(() {
                // sort interface by device name and 
                interfaces.add(ic);
                interfaces.sort((a, b) {
                  var compareResult = a.getDeviceName().compareTo(b.getDeviceName());
                  if (compareResult == 0) {
                    compareResult = a .getInterfaceName().compareTo(b.getInterfaceName());
                  }
                  return compareResult;
                });
                // interfaces = [...interfaces, ic];
              });
            }
          }
        }
        // final payload =
        // MqttPublishPayload.bytesToStringAsString(message.);

        // print('Received message:$payload from topic: ${c[0].topic}>');

        // sort and put in my map
        
      });
    });

    /*
    Future.delayed(Duration(seconds: 2), () async {
      List<InterfaceConnection> newInterfaces = [];

      newInterfaces.add(findPlatform() as InterfaceConnection);

      for (var interface in interfaces) {
        if (interface.info["type"] != "platform") {
          newInterfaces.add(interface);
        }
      }

      interfaces = newInterfaces;
    });
    */
  }

  // Build item of the grid that control the interfaces
  Widget interfaceControlItemBuiler(context, index) {
    // Get the type of the interface

    if (index >= interfaces.length) {
      return Container();
    }

    final ic = interfaces[index];
    final type = ic.info["type"];
    
    switch (type) {
      case "blc":
        return IcBlc(ic);
      case "bpc":
        return IcBpc(ic);
      case "platform":
        return IcPlatform(ic);
      case "powermeter":
        return IcPowermeter(ic);
      case "relay":
        return IcRelay(ic);
      case "video":
        return IcVideo(ic);
      default:
        print("!!!! $type");
        return IcNotManaged(ic);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;

    final int columns = (width / 300.0).round();

    return Scaffold(
      // appBar: getAppBar("UserSpace"),
      appBar: getAppBarUserSpace("Userspace", context),
      body: 
      /*
      ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: interfaces.length,

        itemBuilder: (BuildContext context, int index) {
          return interfaceControlItemBuiler(context, index);
        },
        separatorBuilder: (context, index) => const Divider(),
      )
      */
      /*
      Column(
        // Start with the platform then display every device
        children: <Widget>[
          Center(
            child: Container(
              height: MediaQuery.sizeOf(context).height / 3,
              width: MediaQuery.sizeOf(context).width / 3,
              child: IcPlatform(findPlatform() as InterfaceConnection),
            )
          ),
        ]
      )
      */
      
      
      
      
      MasonryGridView.count(
        crossAxisCount: columns,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: interfaceControlItemBuiler
      )
      

    );
  }
}
