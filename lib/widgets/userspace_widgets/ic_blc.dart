import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'templates.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';


// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IcBlc extends StatefulWidget {
  const IcBlc(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcBlc> createState() => _IcBlcState();
   
}

class _IcBlcState extends State<IcBlc> {
  bool? _enableValueReq;
  bool? _enableValueEff;

  int _powerDecimals = 3;
  double? _powerMin;
  double? _powerMax;

  double? _powerValueReq;
  double? _powerValueEff;

  double? _powerPercentageReq;
  double? _powerPercentageEff;

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
        final recMess = c[0].payload as MqttPublishMessage;

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
                    if (_powerMax != null) {
                      _powerPercentageReq = _powerValueEff! / _powerMax! * 100;
                      _powerPercentageEff = _powerValueEff! / _powerMax! * 100;
                    }
                    if (sync) {
                      _powerValueReq = _powerValueEff;
                    }
                  }

                  if (field.key == "min") {
                    _powerMin = valueToDouble(field.value);
                  }
                  if (field.key == "max") {
                    _powerMax = valueToDouble(field.value);
                    if (_powerValueReq != null && _powerValueEff != null) {
                      _powerPercentageReq = _powerValueReq! / _powerMax! * 100;
                      _powerPercentageEff = _powerValueEff! / _powerMax! * 100;
                    }
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
                    _currentMin = valueToDouble(field.value);
                  }
                  if (field.key == "max") {
                    _currentMax = valueToDouble(field.value);
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

    widget._interfaceConnection.client
        .subscribe(attsTopic, MqttQos.atLeastOnce);

  }

  /// Perform MQTT Subscriptions at the start of the component
  ///
  @override
  void initState() {
    super.initState();

    // subscribe to info and atts ?
    Future.delayed(const Duration(milliseconds: 500), initializeMqttSubscription);
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
        _powerPercentageEff == _powerPercentageReq &&
        _currentValueReq == _currentValueEff &&
        _modeValueReq == _modeValueEff) {
      return null;
    } else {
      return () {
        if (_powerPercentageEff != _powerPercentageReq) {
          MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
 
          // Transform percentage in value
          double powerValue = (1/100) * _powerPercentageReq! * _powerMax!;

          Map<String, dynamic> data = {
            "power": {"value": powerValue}
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
          _currentValueReq = num.parse(_currentValueReq!.toStringAsFixed(_currentDecimals)).toDouble();

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
        _powerPercentageEff == _powerPercentageReq &&
        _currentValueReq == _currentValueEff &&
        _modeValueReq == _modeValueEff) {
      return null;
    } else {
      return () {
        if (_powerValueEff != _powerValueReq) {
          _powerValueReq = _powerValueEff;
        }
        if (_powerPercentageEff != _powerPercentageReq) {
          _powerPercentageReq = _powerPercentageEff;
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

    print(target);

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

  // Show power or current slider according to mod selected
  Widget powerOrCurrentSlider() {

    if (_modeValueEff != null) {
      if (_modeValueEff!.compareTo("constant_power") == 0) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // Show power in percentage and the value
            Text(
              'Power : ${double.parse(_powerPercentageReq!.toStringAsFixed(_powerDecimals))}% (${formatValueInBaseMilliMicro(double.parse(_powerValueReq!.toStringAsFixed(_powerDecimals)), "", "W")})',
              style: TextStyle(
                color: black
              ),
            ),
            Slider(
              value: _powerPercentageReq!,
              onChanged: (value) {
                setState(() {
                  _powerPercentageReq =
                      double.parse((value).toStringAsFixed(_powerDecimals));
                  
                  // Transform percentage in value
                  double powerValue = (1/100) * _powerPercentageReq! * _powerMax!;
                  _powerValueReq = 
                      double.parse((powerValue).toStringAsFixed(_powerDecimals));
                });
              },
              min: 0,
              max: 100,
            ),
          ],
        );
      } else if (_modeValueEff!.compareTo("constant_current") == 0) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              formatValueInBaseMilliMicro(double.parse(_currentValueReq!.toStringAsFixed(_currentDecimals)), "Current : ", "A"),
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
          ],
        );
      } 
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {

    if (_enableValueEff != null &&
        _powerValueReq != null &&
        _powerPercentageReq != null &&
        _currentValueReq != null &&
        _modeValueReq != null) {
        
      // Button to start laser and buttons to confirm changing mod 
      // or send the value of power or current choose with the slider
      Widget enableButton = Row(
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
          const Spacer(),
          Switch(
              value: _enableValueEff!,
              onChanged: enableValueSwitchOnChanged()),
        ],
      );
      
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
                )
              ],
              value: _modeValueReq!,
              onChanged: (String? value) {
                setState(() {
                  _modeValueReq = value!;
                });
              }
            ),
            powerOrCurrentSlider(),
            enableButton
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
