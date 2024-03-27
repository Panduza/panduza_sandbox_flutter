import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/templates.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';

class IcBpc extends StatefulWidget {
  const IcBpc(this._interfaceConnection, {
    super.key,
    this.isEdit = false,
    this.prefs, 
    this.deviceName,
    this.editSetState
  });

  final InterfaceConnection _interfaceConnection;
  final bool isEdit;
  final SharedPreferences? prefs;
  final String? deviceName;
  final Function? editSetState;


  @override
  _IcBpcState createState() => _IcBpcState();
}

class _IcBpcState extends State<IcBpc> {
  
  bool? _enableValueReq = false;
  bool? _enableValueEff = false;

  double? _voltageValueReq = 0;
  double? _voltageValueEff = 0;

  double? _currentValueReq = 0;
  double? _currentValueEff = 0;
  
  /*
  bool? _enableValueReq;
  bool? _enableValueEff;

  double? _voltageValueReq;
  double? _voltageValueEff;

  double? _currentValueReq;
  double? _currentValueEff;
  */

  ///
  ///
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    print("============");
    print('Received ${c[0].topic} from ${widget._interfaceConnection.topic} ');
    
    // print("ouaf\n");
    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      print("test = ${c[0].topic}");
      if (!c[0].topic.endsWith('/info')) {
        print("success = ${c[0].topic}");
        final recMess = c![0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);

        print(jsonObject);

        // Map<String, dynamic> updateAtts = Map.from(_attsEffective);

        setState(() {
          for (MapEntry<String, dynamic> atts in jsonObject.entries) {
            for (MapEntry<String, dynamic> field in atts.value.entries) {
              print('${atts.key} ${field.key} => ${field.value}');

              switch (atts.key) {
                case "enable":
                  if (field.key == "value") {
                    _enableValueEff = field.value;
                    // _enableValueReq ??= _enableValueEff;
                    _enableValueReq = _enableValueEff;
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
                    // _voltageValueReq ??= _voltageValueEff;
                    _voltageValueReq = _voltageValueEff;
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
                    // _currentValueReq ??= _currentValueEff;
                    _currentValueReq = _currentValueEff;
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

  /*
  @override
  void dispose() {
    widget._interfaceConnection.client.updates.
    super.dispose();
  }
  */

  /// Perform MQTT Subscriptions at the start of the component
  ///
  @override
  void initState() {
    super.initState();

    print("pouf");

    // subscribe to info and atts ?
    Future.delayed(const Duration(milliseconds: 1), initializeMqttSubscription);
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
      return basicCard(
        Column(
          children: [
            cardHeadLine(
              widget._interfaceConnection, 
              widget.isEdit,
              deviceName: widget.deviceName,
              prefs: widget.prefs,
              editSetState: widget.editSetState
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Volt',
                      style: TextStyle(
                        color: white,
                        fontSize: 12
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: _voltageValueReq!,
                        activeColor: blue,
                        onChanged: (value) {
                          setState(() {
                            _voltageValueReq = value;
                          });
                        },
                        label: '${double.parse(_voltageValueReq!.toStringAsFixed(2))} V',
                        // min: _attsEffective["voltage"]["min"],
                        // max: _attsEffective["voltage"]["max"],
                      ),
                    ),
                    Text(
                      // 'Voltage : ${double.parse(_voltageValueReq!.toStringAsFixed(2))}V',
                      '${double.parse(_voltageValueReq!.toStringAsFixed(2))} V',
                      style: TextStyle(
                        color: white,
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget> [
                    Text(
                      'Current',
                      style: TextStyle(
                        color: white,
                        fontSize: 12
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: _currentValueReq!,
                        activeColor: blue,
                        onChanged: (value) {
                          setState(() {
                            _currentValueReq = value;
                          });
                        },
                        label: '${double.parse(_currentValueReq!.toStringAsFixed(2))} V',
                        // min: 0.0,
                        // max: 100.0,
                      ),
                    ),
                    
                    Text(
                      // 'Current : ${double.parse(_currentValueReq!.toStringAsFixed(2))}V',
                      '${double.parse(_currentValueReq!.toStringAsFixed(2))} V',
                      style: TextStyle(
                        color: white,
                        fontSize: 12
                      ),
                    ),
                  ]
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    iconSize: 14,
                    icon: const Icon(
                      Icons.close
                    ),
                    onPressed: applyVoltageCurrentRequest(),
                    style: OutlinedButton.styleFrom(
                      disabledBackgroundColor: white,
                      foregroundColor: Colors.red,
                      side: BorderSide(
                        color: (applyVoltageCurrentRequest() != null)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    // child: const Text("Cancel"),
                  ),
                ),
                
                const SizedBox(
                  width: 10,
                ),
                */
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    iconSize: 16,
                    icon: const Icon(
                      Icons.check
                    ),
                    onPressed: applyVoltageCurrentRequest(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      disabledBackgroundColor: white,
                      backgroundColor: Colors.green, // Green background
                      foregroundColor: Colors.white, // White foreground
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 35,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      value: _enableValueEff!,
                      onChanged: enableValueSwitchOnChanged(),
                      activeColor: blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            )
          ],
        )
      );
    } else {
      return Card();
    }
  }
}
