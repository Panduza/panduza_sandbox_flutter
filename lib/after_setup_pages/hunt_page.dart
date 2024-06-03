import 'package:flutter/material.dart';
import 'dart:convert';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/data/device_config.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// import 'userspace/ic_bpc.dart';
// import 'userspace/ic_not_managed.dart';
// import 'userspace/ic_platform.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';

// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../data/platform_config.dart';

class HuntPage extends StatefulWidget {
  HuntPage(this._interfaceConnection, this._platformConfig, {super.key});

  final InterfaceConnection _interfaceConnection;

  PlatformConfig _platformConfig;

  @override
  State<HuntPage> createState() => _HuntPageState();
}

class _HuntPageState extends State<HuntPage> {
  bool hunting = false;

  List<dynamic> _instances = [];

  ///
  ///
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    print("============");
    // print(
    //     'HUNT RECCC ${c[0].topic} from ${widget._interfaceConnection.topic} ');

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c![0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);
        print(jsonObject);

        List<dynamic> update = [];

        if (jsonObject.containsKey("devices")) {
          print("devices");
          if (jsonObject["devices"].containsKey("store")) {
            print("store");
            Map<dynamic, dynamic> store = jsonObject["devices"]["store"];

            for (var v in store.keys) {
              // print(v);
              // print(store[v]);

              List<dynamic> instances = store[v]["instances"];
              // print("instances");
              // print(instances);
              if (instances.isNotEmpty) {
                for (var i in instances) {
                  update.add(i);
                }
              }
            }

            print("update instances");
            print(update);
            if (update.isNotEmpty) {
              setState(() {
                _instances = update;
              });
            }
          }
        }
      }
    }
  }

  /// Initialize MQTT Subscriptions
  ///
  void initializeMqttSubscription() async {
    widget._interfaceConnection.client.updates!.listen(onMqttMessage);

    String attsTopic = "${widget._interfaceConnection.topic}/atts/#";
    // print(attsTopic);
    Subscription? sub = widget._interfaceConnection.client
        .subscribe(attsTopic, MqttQos.atLeastOnce);

    // if (sub != null) {
    //   print("coool !!");
    // } else {
    //   print("nullllll");
    // }
  }

  ///
  ///
  void startHuntSession() {
    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

    Map<String, dynamic> data = {
      "devices": {"hunting": true}
    };

    String jsonString = jsonEncode(data);

    builder.addString(jsonString);
    final payload = builder.payload;

    String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

    widget._interfaceConnection.client
        .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);
  }

  ///
  ///
  List<Widget> instancesCardList() {
    List<Widget> widgets = [];

    for (var i in _instances) {
      widgets.add(Card(
          child: Column(children: [
        Text(i.toString()),
        ElevatedButton(
          onPressed: () {
            widget._platformConfig.devices
                .insert(0, DeviceConfig.FromInstanceMap(i));

            Navigator.pop(context, true);
          },
          // style: ElevatedButton.styleFrom(
          //   elevation: 0,
          //   backgroundColor: Colors.green, // Green background
          //   foregroundColor: Colors.white, // White foreground
          // ),
          child: const Text("Use"),
        ),
      ])));
    }
    return widgets;
  }

  /// Perform MQTT Subscriptions at the start of the component
  ///
  @override
  void initState() {
    super.initState();

    // subscribe to info and atts ?
    Future.delayed(const Duration(milliseconds: 1), initializeMqttSubscription);
  }

  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;

    final int columns = (width / 300.0).round();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Hunt'),
            ElevatedButton(
              onPressed: () {
                widget._platformConfig.devices.insert(
                  0,
                  DeviceConfig(
                    ref: "panduza.fake_power_supply", 
                    settings: {}, 
                    name: "empty"
                  )
                );
                // print(widget._platformConfig.devices.length);
                Navigator.pop(context, true);
              },
              // style: ElevatedButton.styleFrom(
              //   elevation: 0,
              //   backgroundColor: Colors.green, // Green background
              //   foregroundColor: Colors.white, // White foreground
              // ),
              child: const Text("Empty"),
            ),
          ]
        )
      ),
      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: columns,
          children: instancesCardList()),
      floatingActionButton: FloatingActionButton(
        onPressed: startHuntSession,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
