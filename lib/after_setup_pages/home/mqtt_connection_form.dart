import 'dart:async';
import 'dart:math';
// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/userspace_page.dart';


class MqttConnectionForm extends StatefulWidget {
  const MqttConnectionForm({Key? key}) : super(key: key);

  @override
  State<MqttConnectionForm> createState() => _MqttConnectionFormState();
}

class _MqttConnectionFormState extends State<MqttConnectionForm> {
  // final _ctrlHost = TextEditingController(text: "localhost");
  // final _ctrlHost = TextEditingController(text: "192.168.1.39");
  final _ctrlHost = TextEditingController(text: "192.168.1.33");
  // final _ctrlHost = TextEditingController(text: "10.3.141.1");
  final _ctrlPort = TextEditingController(text: "1883");
  late MqttServerClient _client;
  bool _isConnecting = false;
  String _connectionStatus = 'Disconnected';

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String generateRandomMqttIdentifier() {
    String test = getRandomString(15);
    // print(test);
    return test;
  }

  String getHost() {
    return _ctrlHost.text;
  }

  int getPort() {
    return int.parse(_ctrlPort.text);
  }

  Future tryConnecting() async {
    if (!_isConnecting) {
      setState(() {
        _isConnecting = true;
        _connectionStatus = 'Connecting...';
      });

      try {
        String host = _ctrlHost.text;
        int port = int.parse(_ctrlPort.text);

        _client = MqttServerClient.withPort(
            host, generateRandomMqttIdentifier(), port);

        await _client.connect();

        setState(() {
          _isConnecting = false;
          _connectionStatus = 'Connected';
        });

        // Fluttertoast.showToast(
        //   msg: 'Connected to MQTT broker successfully',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        // );
      } catch (error) {
        setState(() {
          _isConnecting = false;
          _connectionStatus = 'Connection failed: ${error.toString()}';
        });
        // Fluttertoast.showToast(
        //   msg: 'Connection to MQTT broker failed',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_connectionStatus == 'Connected') {}

    if (_isConnecting) {
      return const CircularProgressIndicator();
    } else {
      return Column(
        children: [
          TextField(
            controller: _ctrlHost,
            // textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Broker Hostname'),
          ),
          TextField(
            controller: _ctrlPort,
            // textAlign: TextAlign.center,
            decoration: const InputDecoration(
              labelText: 'Broker Port',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              tryConnecting().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserspacePage(
                            broker_connection_info: BrokerConnectionInfo(
                                getHost(), getPort(), _client),
                          )),
                );
                // Navigator.of(context).pushNamed('/userspace', arguments: {

                // });
              });
            },
            child: const Text('Connect'),
          ),
          Text('Connection Status: $_connectionStatus'),
        ],
      );
    }
  }
}
