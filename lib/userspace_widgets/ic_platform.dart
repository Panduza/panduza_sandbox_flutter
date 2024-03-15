import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:panduza_sandbox_flutter/pages/platform_page.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/templates.dart';

class IcPlatform extends StatefulWidget {
  IcPlatform(this._interfaceConnection);

  InterfaceConnection _interfaceConnection;

  @override
  _IcPlatformState createState() => _IcPlatformState();
}

class _IcPlatformState extends State<IcPlatform> {
  String _value = 'fake psu';

  void _handleDropdownValueChanged(String newValue) {
    setState(() {
      _value = newValue;
    });
  }

  void _handleButtonPress() {
    print(_value);

    if (_value == 'fake psu') {
      print(widget._interfaceConnection.topic);

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
          widget._interfaceConnection.topic + "/cmds/set",
          MqttQos.atLeastOnce,
          payload!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return basicCard(
      Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10
        ),
        child: Column(
          children: [
            cardHeadLine(widget._interfaceConnection),
            const SizedBox(
              height: 5,
            ),
            Container (
              width: 120,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Center (
                child: DropdownButton<String>(
                  value: _value,
                  dropdownColor: white,
                  underline: SizedBox.shrink(),
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
              )
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _handleButtonPress,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => white)
                  ),
                  child: Text(
                    'Send Request',
                    style: TextStyle(
                      color: black
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          PlatformPage(widget._interfaceConnection)
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => white)
                  ),
                  child: Text(
                    'Configuration',
                    style: TextStyle(
                      color: black
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      )
      
    );
  }
}
