import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'templates.dart';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IcBpc extends StatefulWidget {
  const IcBpc(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcBpc> createState() => _IcBpcState();
 
}

class _IcBpcState extends State<IcBpc> {

  bool? _enableValueReq;
  bool? _enableValueEff;

  int _voltageDecimal = 3;
  double _voltageMin = 0;
  double _voltageMax = 1;
  double? _voltageValueReq;
  double? _voltageValueEff;

  int _currentDecimal = 3;
  double _currentMin = 0;
  double _currentMax = 1;
  double? _currentValueReq;
  double? _currentValueEff;

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? mqttSubscription;

  ///
  ///
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c[0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);

        setState(() {
          for (MapEntry<String, dynamic> atts in jsonObject.entries) {
            for (MapEntry<String, dynamic> field in atts.value.entries) {
              switch (atts.key) {
                case "enable":
                  if (field.key == "value") {
                    _enableValueEff = field.value;
                    _enableValueReq ??= _enableValueEff;
                  }
                  break;

                case "voltage":
                  if (field.key == "value") {
                    switch (field.value.runtimeType) {
                      case int:
                        _voltageValueEff = field.value.toDouble();
                      case double:
                        _voltageValueEff = field.value;
                    }
                    _voltageValueReq ??= _voltageValueEff;
                  }

                  if (field.key == "min") {
                    _voltageMin = valueToDouble(field.value);
                  }
                  if (field.key == "max") {
                    _voltageMax = valueToDouble(field.value);
                  }
                  if (field.key == "decimals") {
                    switch (field.value.runtimeType) {
                      case int:
                        _voltageDecimal = field.value;
                      case double:
                        _voltageDecimal = (field.value as double).toInt();
                    }
                  }
                  break;

                case "current":
                  if (field.key == "value") {
                    switch (field.value.runtimeType) {
                      case int:
                        _currentValueEff = field.value.toDouble();
                      case double:
                        _currentValueEff = field.value;
                    }
                    _currentValueReq ??= _currentValueEff;
                  }

                  if (field.key == "min") {
                    _currentMin = valueToDouble(field.value);
                  }
                  if (field.key == "max") {
                    _currentMax = valueToDouble(field.value);
                  }
                  if (field.key == "decimals") {
                    switch (field.value.runtimeType) {
                      case int:
                        _currentDecimal = field.value;
                      case double:
                        _currentDecimal = (field.value as double).toInt();
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
    widget._interfaceConnection.client
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
  void Function()? applyVoltageCurrentRequest() {
    if (_voltageValueEff == _voltageValueReq &&
        _currentValueReq == _currentValueEff) {
      return null;
    } else {
      return () {
        if (_voltageValueEff != _voltageValueReq) {
          MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

          // Send a voltage value approx to decimal attribute 
          _voltageValueReq = num.parse(_voltageValueReq!.toStringAsFixed(_voltageDecimal)).toDouble();

          Map<String, dynamic> data = {
            "voltage": {"value": _voltageValueReq!}
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

          // Send a current value approx to decimal attribute 
          _currentValueReq = num.parse(_currentValueReq!.toStringAsFixed(_currentDecimal)).toDouble();

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
      };
    }
  }

  
  void Function()? cancelPowerCurrentRequest() {
    if (_voltageValueReq == _voltageValueEff &&
        _currentValueReq == _currentValueEff 
      ) {
      return null;
    } else {
      return () {
        if (_voltageValueReq != _voltageValueEff) {
          _voltageValueReq = _voltageValueEff;
        }
        if (_currentValueEff != _currentValueReq) {
          _currentValueReq = _currentValueEff;
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
        _voltageValueReq != null &&
        _currentValueReq != null) {
      return Card(
          child: Column(
        children: [
          cardHeadLine(widget._interfaceConnection),
          Text(
            'Voltage : ${double.parse(_voltageValueReq!.toStringAsFixed(_voltageDecimal))}V',
            style: TextStyle(
              color: black
            ),
          ),
          Slider(
            value: _voltageValueReq!,
            onChanged: (value) {
              setState(() {
                _voltageValueReq = value;
              });
            },
            min: _voltageMin,
            max: _voltageMax
          ),
          Text(
            'Current : ${double.parse(_currentValueReq!.toStringAsFixed(_currentDecimal))}V',
            style: TextStyle(
              color: black
            ),
          ),
          Slider(
            value: _currentValueReq!,
            onChanged: (value) {
              setState(() {
                _currentValueReq = value;
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
                    color: (applyVoltageCurrentRequest() != null)
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: applyVoltageCurrentRequest(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.green, // Green background
                  foregroundColor: Colors.white, // White foreground
                ),
                child: const Text("Apply"),
              ),
              const Spacer(),
              Switch(
                  value: _enableValueEff!,
                  onChanged: enableValueSwitchOnChanged()),
            ],
          )
        ],
      ));
    } else {
      return const Card();
    }
  }
}
