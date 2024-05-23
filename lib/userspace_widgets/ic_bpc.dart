import 'package:flutter/material.dart';
import 'templates.dart';
import '../../data/interface_connection.dart';

import 'dart:convert';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IcBpc extends StatefulWidget {
  const IcBpc(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  _IcBpcState createState() => _IcBpcState();
}

class _IcBpcState extends State<IcBpc> {
  bool? _enableValueReq;
  bool? _enableValueEff;

  double? _voltageValueReq;
  double? _voltageValueEff;

  double? _currentValueReq;
  double? _currentValueEff;

  ///
  ///
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    // print("============");
    // print('Received ${c[0].topic} from ${widget._interfaceConnection.topic} ');

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      // print(c[0].topic);
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c![0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);
        
        // print(jsonObject);

        // Map<String, dynamic> updateAtts = Map.from(_attsEffective);

        setState(() {
          for (MapEntry<String, dynamic> atts in jsonObject.entries) {
            for (MapEntry<String, dynamic> field in atts.value.entries) {
              // print('${atts.key} ${field.key} => ${field.value}');
              switch (atts.key) {
                case "enable":
                  if (field.key == "value") {
                    _enableValueEff = field.value;
                    _enableValueReq ??= _enableValueEff;
                  }
                  break;

                case "voltage":
                  if (field.key == "value") {
                    // print("pokkk !! ${field.value.runtimeType}");
                    switch (field.value.runtimeType) {
                      case int:
                        _voltageValueEff = field.value.toDouble();
                      case double:
                        _voltageValueEff = field.value;
                    }
                    _voltageValueReq ??= _voltageValueEff;
                  }
                  break;

                case "current":
                  if (field.key == "value") {
                    // print("pokkk !! ${field.value.runtimeType}");
                    switch (field.value.runtimeType) {
                      case int:
                        _currentValueEff = field.value.toDouble();
                      case double:
                        _currentValueEff = field.value;
                    }
                    _currentValueReq ??= _currentValueEff;
                  }
                  break;
              }
            }
          }
        });
        // print(updateAtts);

        // setState(() {
        //   _attsEffective = updateAtts;
        // });
        // _attsEffective

        // print(jsonObject.runtimeType);
      }
    } else {
      // print('not good:');
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
          // Column(
          //   children: [
          //     TextFormField(
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //       ),
          //       // controller: sliderController,
          //     ),
          //     TextFormField(
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //       ),
          //       // controller: sliderController,
          //     ),
          //   ],
          // ),
          Text(
              'Voltage : ${double.parse(_voltageValueReq!.toStringAsFixed(2))}V'),
          Slider(
            value: _voltageValueReq!,
            onChanged: (value) {
              setState(() {
                _voltageValueReq = value;
              });
            },
            // min: _attsEffective["voltage"]["min"],
            // max: _attsEffective["voltage"]["max"],
          ),
          Text(
              'Current : ${double.parse(_currentValueReq!.toStringAsFixed(2))}V'),
          Slider(
            value: _currentValueReq!,
            onChanged: (value) {
              setState(() {
                _currentValueReq = value;
              });
            },
            // min: 0.0,
            // max: 100.0,
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: applyVoltageCurrentRequest(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(
                    color: (applyVoltageCurrentRequest() != null)
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                child: const Text("Cancel"),
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
              Spacer(),
              Switch(
                  value: _enableValueEff!,
                  onChanged: enableValueSwitchOnChanged()),
            ],
          )
        ],
      ));
    } else {
      return Card();
    }
  }
}
