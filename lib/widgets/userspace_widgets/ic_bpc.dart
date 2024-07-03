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

  // If request made on the slider apply it after a small timer
  bool isRequestingVoltage = false;
  Timer? _applyVoltageTimer;

  bool isRequestingCurrent = false;
  Timer? _applyCurrentTimer;

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
                    _enableValueReq = _enableValueEff;
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

                    _voltageValueReq = _voltageValueEff;
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
                    _currentValueReq = _currentValueEff;
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
    Future.delayed(const Duration(milliseconds: 500), initializeMqttSubscription);
  }

  @override
  void dispose() {
    mqttSubscription?.cancel();
    _applyVoltageTimer?.cancel();
    _applyCurrentTimer?.cancel();
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
  void applyVoltageCurrentRequest() {
    if (_voltageValueEff == _voltageValueReq &&
        _currentValueReq == _currentValueEff) {
      // Not suppose to happen
    } else {
      if (_voltageValueEff != _voltageValueReq && 
          isRequestingVoltage == false) {
        
        // Not possible to request anymore before this sending has been made
        // User can change send value only every 50 milliseconds
        isRequestingVoltage = true;

        // Send voltage request to broker after 50 milliseconds to not 
        // send request while at each tick of the slider
        _applyVoltageTimer = Timer(const Duration(milliseconds: 50), () {

          // Send a voltage value approx to decimal attribute 
          _voltageValueReq = num.parse(_voltageValueReq!.toStringAsFixed(_voltageDecimal)).toDouble();

          basicSendingMqttRequest("voltage", "value", _voltageValueReq!, widget._interfaceConnection);

          // User can remake a another sending
          isRequestingVoltage = false;
        });
      }
      if (_currentValueEff != _currentValueReq && 
          isRequestingCurrent == false) {

        // Not possible to request anymore before this sending has been made
        // User can change send value only every 50 milliseconds
        isRequestingCurrent = true;

        // Send current request to broker after 50 milliseconds to not 
        // send request while at each tick of the slider
        _applyVoltageTimer = Timer(const Duration(milliseconds: 50), () {

          // Send a current value approx to decimal attribute 
          _currentValueReq = num.parse(_currentValueReq!.toStringAsFixed(_currentDecimal)).toDouble();

          basicSendingMqttRequest("current", "value", _currentValueReq!, widget._interfaceConnection);

          // User can remake a another sending
          isRequestingCurrent = false;
        });
      }
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

    if ((_voltageValueEff != null && _voltageValueEff! < 0) &&
        (_voltageValueEff != null && _currentValueEff! < 0)) {
      // With just turn on/off button
      return Card(
        child: Row(
          children: [
            Column(
              children: [
                cardHeadLine(widget._interfaceConnection),
              ],
            ),
            const Spacer(),
            Switch(
              value: _enableValueEff!,
              onChanged: enableValueSwitchOnChanged()
            ),
          ],
        )
      );
    } else if (_enableValueEff != null &&
        _voltageValueReq != null &&
        _currentValueReq != null) {
      // Full bpc
      return Card(
        child: Column(
          children: [
            Row(
              children: [
                cardHeadLine2(widget._interfaceConnection),
                const Spacer(),
                Switch(
                  value: _enableValueEff!,
                  onChanged: enableValueSwitchOnChanged()
                ),
              ],
            ),
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

                  // Send value to broker only after timer
                  applyVoltageCurrentRequest();
                });
              },
              min: _voltageMin,
              max: _voltageMax
            ),
            Text(
              'Current : ${double.parse(_currentValueReq!.toStringAsFixed(_currentDecimal))}A',
              style: TextStyle(
                color: black
              ),
            ),
            Slider(
              value: _currentValueReq!,
              onChanged: (value) {
                setState(() {
                  _currentValueReq = value;
                  applyVoltageCurrentRequest();
                });
              },
              min: _currentMin,
              max: _currentMax,
            ),
            // Row(
            //   children: [
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     const Spacer(),
            //     Switch(
            //       value: _enableValueEff!,
            //       onChanged: enableValueSwitchOnChanged()
            //     ),
            //   ],
            // )
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
