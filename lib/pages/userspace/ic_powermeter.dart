import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'templates.dart';
import '../../data/interface_connection.dart';

import 'dart:convert';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IcPowermeter extends StatefulWidget {
  const IcPowermeter(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  _IcPowermeterState createState() => _IcPowermeterState();
}

class _IcPowermeterState extends State<IcPowermeter> {
  // bool? _enableValueReq;
  // bool? _enableValueEff;

  // double? _voltageValueReq;
  // double? _voltageValueEff;

  // double? _currentValueReq;
  // double? _currentValueEff;

  double _value = 0;

  ///
  ///
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    print("============");
    print('Received ${c[0].topic} from ${widget._interfaceConnection.topic} ');

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
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
                case "measure":
                  if (field.key == "value") {
                    double update_val = 0;
                    switch (field.value.runtimeType) {
                      case int:
                        update_val = field.value.toDouble();
                      case double:
                        update_val = field.value;
                    }
                    setState(() {
                      _value = update_val;
                    });
                  }
                  break;
              }

              //   case "voltage":
              //     if (field.key == "value") {
              //       // print("pokkk !! ${field.value.runtimeType}");
              //       switch (field.value.runtimeType) {
              //         case int:
              //           _voltageValueEff = field.value.toDouble();
              //         case double:
              //           _voltageValueEff = field.value;
              //       }
              //       _voltageValueReq ??= _voltageValueEff;
              //     }
              //     break;

              //   case "current":
              //     if (field.key == "value") {
              //       // print("pokkk !! ${field.value.runtimeType}");
              //       switch (field.value.runtimeType) {
              //         case int:
              //           _currentValueEff = field.value.toDouble();
              //         case double:
              //           _currentValueEff = field.value;
              //       }
              //       _currentValueReq ??= _currentValueEff;
              //     }
              //     break;
              // }
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

  late TextEditingController _freqController;
  late TextEditingController _freqControllerRequested;

  /// Perform MQTT Subscriptions at the start of the component
  ///
  @override
  void initState() {
    super.initState();

    // subscribe to info and atts ?
    Future.delayed(const Duration(milliseconds: 1), initializeMqttSubscription);

    _freqController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void Function(bool)? enableValueSwitchOnChanged() {
  //   if (_enableValueReq != _enableValueEff) {
  //     return null;
  //   } else {
  //     return (value) {
  //       enableValueToggleRequest();
  //     };
  //   }
  // }

  ///
  ///
  ///
  // void Function()? applyVoltageCurrentRequest() {
  //   if (_voltageValueEff == _voltageValueReq &&
  //       _currentValueReq == _currentValueEff) {
  //     return null;
  //   } else {
  //     return () {
  //       if (_voltageValueEff != _voltageValueReq) {
  //         MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

  //         Map<String, dynamic> data = {
  //           "voltage": {"value": _voltageValueReq!}
  //         };

  //         String jsonString = jsonEncode(data);

  //         builder.addString(jsonString);
  //         final payload = builder.payload;

  //         String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

  //         widget._interfaceConnection.client
  //             .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);
  //       }
  //       if (_currentValueEff != _currentValueReq) {
  //         MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

  //         Map<String, dynamic> data = {
  //           "current": {"value": _currentValueReq!}
  //         };

  //         String jsonString = jsonEncode(data);

  //         builder.addString(jsonString);
  //         final payload = builder.payload;

  //         String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

  //         widget._interfaceConnection.client
  //             .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);
  //       }
  //     };
  //   }
  // }

  // void enableValueToggleRequest() {
  //   if (_enableValueEff == null) {
  //     return;
  //   }
  //   bool target = _enableValueEff! ? false : true;

  //   MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

  //   // Example JSON object
  //   Map<String, dynamic> data = {
  //     "enable": {"value": target}
  //   };

  //   // Convert JSON object to string
  //   String jsonString = jsonEncode(data);

  //   builder.addString(jsonString);
  //   final payload = builder.payload;

  //   String cmdsTopic = "${widget._interfaceConnection.topic}/cmds/set";

  //   widget._interfaceConnection.client
  //       .publishMessage(cmdsTopic, MqttQos.atLeastOnce, payload!);

  //   setState(() {
  //     _enableValueReq = target;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cardHeadLine(widget._interfaceConnection),
        Text("${_value.toString()}W"),
        Row(
          children: [
            SizedBox(
                width: 100,
                child: TextField(
                  controller: _freqController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                )),
            const Text("read per sec"),
          ],
        )
      ],
    ));
  }
}
