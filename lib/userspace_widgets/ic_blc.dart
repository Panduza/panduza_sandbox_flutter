import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'templates.dart';
import '../../data/interface_connection.dart';

import 'dart:convert';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IcBlc extends StatefulWidget {
  const IcBlc(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcBlc> createState() => _IcBlcState();
   
}

double value_to_double(dynamic value) {
  switch (value.runtimeType) {
    case int:
      return value.toDouble();
    case double:
      return value;
  }
  return 0.0;
}

class _IcBlcState extends State<IcBlc> {
  bool? _enableValueReq;
  bool? _enableValueEff;

  int _powerDecimals = 3;
  double _powerMin = 0;
  double _powerMax = 0.1;
  double? _powerValueReq;
  double? _powerValueEff;

  int _currentDecimals = 3;
  double _currentMin = 0;
  double _currentMax = 0.1;
  double? _currentValueReq;
  double? _currentValueEff;

  String? _modeValueReq;
  String? _modeValueEff;

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? mqttSubscription;

  ///
  ///
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c![0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);

        setState(() {
          for (MapEntry<String, dynamic> atts in jsonObject.entries) {
            for (MapEntry<String, dynamic> field in atts.value.entries) {

              switch (atts.key) {
                case "mode":
                  if (field.key == "value") {
                    bool sync = false;
                    if (_modeValueEff == _modeValueReq ||
                        _modeValueReq == null) {
                      sync = true;
                    }

                    _modeValueEff = field.value;
                    if (sync) {
                      _modeValueReq = _modeValueEff;
                    }
                  }

                  break;

                case "enable":
                  if (field.key == "value") {
                    bool sync = false;
                    if (_enableValueEff == _enableValueReq ||
                        _enableValueReq == null) {
                      sync = true;
                    }

                    _enableValueEff = field.value;
                    if (sync) {
                      _enableValueReq = _enableValueEff;
                    }
                  }

                  break;

                case "power":
                  if (field.key == "value") {
                    bool sync = false;
                    if (_powerValueEff == _powerValueReq ||
                        _powerValueReq == null) {
                      sync = true;
                    }

                    

                    switch (field.value.runtimeType) {
                      case int:
                        _powerValueEff = field.value.toDouble();
                      case double:
                        _powerValueEff = field.value;
                    }
                    if (sync) {
                      _powerValueReq = _powerValueEff;
                    }
                  }

                  if (field.key == "min") {
                    _powerMin = value_to_double(field.value);
                  }
                  if (field.key == "max") {
                    _powerMax = value_to_double(field.value);
                  }
                  if (field.key == "decimals") {
                    switch (field.value.runtimeType) {
                      case int:
                        _powerDecimals = field.value;
                      case double:
                        _powerDecimals = (field.value as double).toInt();
                    }
                  }
                  
                  break;

                case "current":
                  if (field.key == "value") {
                    bool sync = false;
                    if (_currentValueEff == _currentValueReq ||
                        _currentValueReq == null) {
                      sync = true;
                    }

                    switch (field.value.runtimeType) {
                      case int:
                        _currentValueEff = field.value.toDouble();
                      case double:
                        _currentValueEff = field.value;
                    }

                    if (sync) {
                      _currentValueReq = _currentValueEff;
                    }
                  }

                  if (field.key == "min") {
                    _currentMin = value_to_double(field.value);
                  }
                  if (field.key == "max") {
                    _currentMax = value_to_double(field.value);
                  }
                  if (field.key == "decimals") {
                    switch (field.value.runtimeType) {
                      case int:
                        _currentDecimals = field.value;
                      case double:
                        _currentDecimals = (field.value as double).toInt();
                    }
                  }

                  break;
              }
            }
          }
        });
      }
    } else {
      // print('not good:');
    }
  }

  /// Initialize MQTT Subscriptions
  ///
  void initializeMqttSubscription() async {
    mqttSubscription = widget._interfaceConnection.client.updates!.listen(onMqttMessage);

    String attsTopic = "${widget._interfaceConnection.topic}/atts/#";
    // print(attsTopic);
    Subscription? sub = widget._interfaceConnection.client
        .subscribe(attsTopic, MqttQos.atLeastOnce);

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
  void dispose() {
    mqttSubscription!.cancel();
    super.dispose();
  }

  void Function(bool)? enableValueSwitchOnChanged() {
    if (_enableValueReq != _enableValueEff) {
      return null;
    } else {
      return (value) {
        enableValueToggleRequest();
      };
    }
  }

  ///
  ///
  ///
  void Function()? applyPowerCurrentRequest() {
    if (_powerValueEff == _powerValueReq &&
        _currentValueReq == _currentValueEff &&
        _modeValueReq == _modeValueEff) {
      return null;
    } else {
      return () {
        if (_powerValueEff != _powerValueReq) {
          MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

          Map<String, dynamic> data = {
            "power": {"value": _powerValueReq!}
          };

          String jsonString = jsonEncode(data);

          builder.addString(jsonString);
          final payload = builder.payload;

          String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

          widget._interfaceConnection.client
              .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);
        }
        if (_currentValueEff != _currentValueReq) {
          MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

          Map<String, dynamic> data = {
            "current": {"value": _currentValueReq!}
          };

          String jsonString = jsonEncode(data);

          builder.addString(jsonString);
          final payload = builder.payload;

          String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

          widget._interfaceConnection.client
              .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);
        }

        if (_modeValueEff != _modeValueReq) {
          MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

          Map<String, dynamic> data = {
            "mode": {"value": _modeValueReq!}
          };

          String jsonString = jsonEncode(data);

          builder.addString(jsonString);
          final payload = builder.payload;

          String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

          widget._interfaceConnection.client
              .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);
        }
      };
    }
  }

  void Function()? cancelPowerCurrentRequest() {
    if (_powerValueEff == _powerValueReq &&
        _currentValueReq == _currentValueEff &&
        _modeValueReq == _modeValueEff) {
      return null;
    } else {
      return () {
        if (_powerValueEff != _powerValueReq) {
          _powerValueReq = _powerValueEff;
        }
        if (_currentValueEff != _currentValueReq) {
          _currentValueReq = _currentValueEff;
        }
        if (_modeValueEff != _modeValueReq) {
          _modeValueReq = _modeValueEff;
        }
        setState(() {});
      };
    }
  }

  void enableValueToggleRequest() {
    if (_enableValueEff == null) {
      return;
    }
    bool target = _enableValueEff! ? false : true;

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

    // Example JSON object
    Map<String, dynamic> data = {
      "enable": {"value": target}
    };

    // Convert JSON object to string
    String jsonString = jsonEncode(data);

    builder.addString(jsonString);
    final payload = builder.payload;

    String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

    widget._interfaceConnection.client
        .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);

    setState(() {
      _enableValueReq = target;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_enableValueEff != null &&
        _powerValueReq != null &&
        _currentValueReq != null &&
        _modeValueReq != null) {
      return Card(
        child: Column(
          children: [
            cardHeadLine(widget._interfaceConnection),
            DropdownButton<String>(
              items: const [
                DropdownMenuItem<String>(
                  value: "constant_power",
                  child: Text("power mode"),
                ),
                DropdownMenuItem<String>(
                  value: "constant_current",
                  child: Text("current mode"),
                ),
                DropdownMenuItem<String>(
                  value: "no_regulation",
                  child: Text("No regulation mode"),
                ),
              ],
              value: _modeValueReq!,
              onChanged: (String? value) {
                setState(() {
                  _modeValueReq = value!;
                });
              }
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Power : ${double.parse(_powerValueReq!.toStringAsFixed(_powerDecimals))}W',
              style: TextStyle(
                color: black
              ),
            ),
            Slider(
              value: _powerValueReq!,
              onChanged: (value) {
                setState(() {
                  _powerValueReq =
                      double.parse((value).toStringAsFixed(_powerDecimals));
                });
              },
              min: _powerMin,
              max: _powerMax,
            ),
            Text(
              'Current : ${double.parse(_currentValueReq!.toStringAsFixed(_currentDecimals))}A',
              style: TextStyle(
                color: black
              ),
            ),
            Slider(
              value: _currentValueReq!,
              onChanged: (value) {
                setState(() {
                  _currentValueReq =
                      double.parse((value).toStringAsFixed(_currentDecimals));
                });
              },
              min: _currentMin,
              max: _currentMax,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: cancelPowerCurrentRequest(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(
                      color: (applyPowerCurrentRequest() != null)
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  // child: const Text("Cancel"),
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: applyPowerCurrentRequest(),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.green, // Green background
                    foregroundColor: Colors.white, // White foreground
                  ),
                  child: const Text("Apply"),
                ),
                Spacer(),
                Switch(
                    value: _enableValueEff!,
                    onChanged: enableValueSwitchOnChanged()),
              ],
            )
          ],
        )
      );
    } else {
      return Card(
          child: Column(children: [
        cardHeadLine(widget._interfaceConnection),
        Text(
          "Wait for data...",
          style: TextStyle(
            color: black
          ),
        )
      ]));
    }
  }
}
