import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/appBar.dart';
import 'hunt_page.dart';
import 'device_page.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/platform_config.dart';


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
    print("update config = $update");

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
        final recMess = c[0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);

        if (jsonObject.containsKey("devices")) {
          if (jsonObject.containsKey("store")) {
            Map<dynamic, dynamic> store = jsonObject["devices"]["store"];
            setState(() {
              _deviceStore = store;
            });
          }
        }
      }

      if (c[0].topic.endsWith('/dtree')) {
        final recMess = c[0].payload as MqttPublishMessage;
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
    widget._interfaceConnection.client
        .subscribe(attsTopic, MqttQos.atLeastOnce);
  }

  List<Widget> deviceListItems() {
    List<Widget> items = [];
    for (var device in _platformConfig.devices) {
      // device.
      items.add(
        ListTile(
          textColor: white,
          title: Text(device.name),
          subtitle: Text(device.ref),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DevicePage(_deviceStore, device)),
            ).then((value) {
              setState(() {});
            });
          },
        )
      );
    }
    return items;
  }

  /// Perform MQTT Subscriptions at the start of the component
  ///
  @override
  void initState() {
    super.initState();

    // subscribe to info and atts ?
    _platformConfig.devices = [];
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
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HuntPage(
                          widget._interfaceConnection, 
                          _platformConfig
                        )
                      ),
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
                  child: const Text("New Device"),
                ),
                ElevatedButton(
                  onPressed: sendConfigToPlatform,
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: const Text("Push Config"),
                ),
              ],
            ),
            // Text("!!! ${_platformConfig.devices.length}"),
            SizedBox(
                height: 400.0, child: ListView(children: deviceListItems()))
          ],
        ),
      ),
    );
  }
}
