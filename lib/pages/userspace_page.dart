import 'package:flutter/material.dart';
import 'dart:convert';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'userspace/ic_blc.dart';
import 'userspace/ic_bpc.dart';
import 'userspace/ic_not_managed.dart';
import 'userspace/ic_platform.dart';
import 'userspace/ic_powermeter.dart';

import '../data/interface_connection.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrokerConnectionInfo {
  String host;
  int port;

  MqttServerClient client;

  BrokerConnectionInfo(this.host, this.port, this.client);
}

class UserspacePage extends StatefulWidget {
  const UserspacePage({super.key, required this.broker_connection_info});

  final BrokerConnectionInfo broker_connection_info;

  @override
  _UserspacePageState createState() => _UserspacePageState();
}

class _UserspacePageState extends State<UserspacePage> {
  List<InterfaceConnection> interfaces = [];

  bool interfaceAlreadyRegistered(InterfaceConnection ic) {
    for (var interface in interfaces) {
      if (interface.topic == ic.topic) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

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

        if (c![0].topic.startsWith("pza") & c![0].topic.endsWith("atts/info")) {
          final recMess = c![0].payload as MqttPublishMessage;

          var topic = c![0]
              .topic
              .substring(0, c![0].topic.length - "/atts/info".length);

          final pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          var jsonObject = json.decode(pt);

          InterfaceConnection ic = InterfaceConnection(
              widget.broker_connection_info.client, topic, jsonObject["info"]);
          if (!interfaceAlreadyRegistered(ic)) {
            if (ic.getType() != "device") {
              setState(() {
                interfaces = [...interfaces, ic];
              });
            }
          }
        }
        // final payload =
        // MqttPublishPayload.bytesToStringAsString(message.);

        // print('Received message:$payload from topic: ${c[0].topic}>');
      });

      widget.broker_connection_info.client
          .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

      MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString('*');
      final payload = builder.payload;
      widget.broker_connection_info.client
          .publishMessage('pza', MqttQos.atLeastOnce, payload!);
    });
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
      default:
        print("!!!! $type");
        return IcNotManaged(ic);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;

    //
    final int columns = (width / 300.0).round();

    return Scaffold(
        appBar: AppBar(
          title: Text('UserSpace'),
        ),
        body: MasonryGridView.count(
            crossAxisCount: columns,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: interfaceControlItemBuiler)

        // body: GridView.builder(
        //   itemCount: interfaces.length,
        //   itemBuilder: interfaceControlItemBuiler,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: columns,
        //   ),
        // ),

        );
  }
}
