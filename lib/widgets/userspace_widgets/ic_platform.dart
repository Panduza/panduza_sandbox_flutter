import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/platform_page.dart';
import 'templates.dart';

class IcPlatform extends StatefulWidget {
  const IcPlatform(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcPlatform> createState() => _IcPlatformState();
}

class _IcPlatformState extends State<IcPlatform> {
  String _value = 'fake psu';

  void _handleDropdownValueChanged(String newValue) {
    setState(() {
      _value = newValue;
    });
  }

  void _handleButtonPress() {
    // print(_value);

    if (_value == 'fake psu') {
      // print(widget._interfaceConnection.topic);

      // /cmds/set
      Map<String, dynamic> content = {
        "dtree": {
          "content": {
            "devices": [
              {
                "ref": "Panduza.FakeBps",
                "settings": {"number_of_channel": 2}
              },
            ]
          }
        }
      };

      MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode(content));
      final payload = builder.payload;

      widget._interfaceConnection.client.publishMessage(
          "${widget._interfaceConnection.topic}/cmds/set",
          MqttQos.atLeastOnce,
          payload!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        cardHeadLine(widget._interfaceConnection),
        Text(widget._interfaceConnection.info["type"],
            style: const TextStyle(color: Colors.red)),
        DropdownButton<String>(
          value: _value,
          items: const [
            DropdownMenuItem(
              value: 'fake psu',
              child: Text('fake psu'),
            ),
            DropdownMenuItem(
              value: 'fake laser',
              child: Text('fake laser'),
            ),
            DropdownMenuItem(
              value: 'real laser',
              child: Text('real laser'),
            ),
          ],
          onChanged: (newValue) {
            _handleDropdownValueChanged(newValue!);
          },
        ),
        ElevatedButton(
          onPressed: _handleButtonPress,
          child: const Text('Send Request'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PlatformPage(widget._interfaceConnection)),
            );
          },
          child: const Text('Configuration'),
        ),
      ],
    ));
  }
}
