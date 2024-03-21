import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:panduza_sandbox_flutter/pages/hunt_page.dart';
import 'package:panduza_sandbox_flutter/pages/device_page.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/data/platform_config.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';

// admin page where he can add the new devices for a specific bench 
// (for the moment you can't choose in which bench add a device 
// it's directly going inside of the default bench)

class PlatformPage extends StatefulWidget {
  const PlatformPage(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<PlatformPage> createState() => _PlatformPageState();
}

class _PlatformPageState extends State<PlatformPage> {
  ///
  ///
  PlatformConfig _platformConfig = PlatformConfig();

  ///
  Map<dynamic, dynamic> _deviceStore = {};

  ///
  ///
  void sendConfigToPlatform() {
    final update = _platformConfig.toMap();
    print("update config = ${update}");

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

    Map<String, dynamic> data = {
      "dtree": {"content": update}
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
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    // print("============");
    // print('Received ${c[0].topic} from ${widget._interfaceConnection.topic} ');

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c![0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);

        if (jsonObject.containsKey("devices")) {
          Map<dynamic, dynamic> store = jsonObject["devices"]["store"];
          setState(() {
            _deviceStore = store;
          });
        }
      }

      if (c[0].topic.endsWith('/dtree')) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        var jsonObject = json.decode(pt);

        print("DTREE $jsonObject");
        PlatformConfig pc =
            PlatformConfig.FromMap(jsonObject["dtree"]["content"]);

        if (pc != _platformConfig) {
          print("difff !!");
          setState(() {
            _platformConfig = pc;
          });
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

  List<Widget> deviceListItems() {
    List<Widget> items = [];
    for (var device in _platformConfig.devices) {
      // device.
      items.add(ListTile(
        title: Text(
          device.name,
          style: TextStyle(
            color: white
          ),
        ),
        subtitle: Text(
          device.ref,
          style: TextStyle(
            color: white
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DevicePage(_deviceStore, _platformConfig, device)),
          ).then((value) {
            setState(() {});
          });
        },
      ));
    }
    return items;
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
    print("!!!!!!!!!!! ${_platformConfig.devices.length}");

    return Scaffold(
      appBar: getAppBar("Platform"),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HuntPage(
                              widget._interfaceConnection, _platformConfig)),
                    ).then((value) {
                      // print(" !!!!!!!!!!! ^^^^ ");
                      setState(() {});
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    // backgroundColor: Colors.green, // Green background
                    // foregroundColor: Colors.white, // White foreground
                  ),
                  child: Text(
                    "New Device",
                    style: TextStyle(
                      color: black
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: sendConfigToPlatform,
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text(
                    "Push config",
                    style: TextStyle(
                      color: black
                    ),
                  ),
                ),
              ],
            ),
            // Text("!!! ${_platformConfig.devices.length}"),
            SizedBox(
              height: 400.0, 
              child: ListView(children: deviceListItems())
            )
          ],
        ),
      ),
    );
  }
}
