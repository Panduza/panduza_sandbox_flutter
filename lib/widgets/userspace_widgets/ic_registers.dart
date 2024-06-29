import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'templates.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';

// import 'dart:async';
import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:panduza_sandbox_flutter/utils/const.dart';
// import 'templates.dart';
// import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'package:mqtt_client/mqtt_client.dart';


class IcRegisters extends StatefulWidget {
  const IcRegisters(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcRegisters> createState() => _IcRegistersState();
}

class _IcRegistersState extends State<IcRegisters> {

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? mqttSubscription;

  int baseAddress = 0;
  int numberOfRegister = 0;
  int registerSize = 0;


  /// Init each value of the powermeter, here just the measure 
  /// powermeter
  /// 
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    // print("============");
    // print('Received ${c[0].topic} from ${widget._interfaceConnection.topic} ');

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c[0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);

        print(jsonObject);


        if (c[0].topic.startsWith("${widget._interfaceConnection.topic}/atts/settings")) {
          print("settings");
        }
        if (c[0].topic.startsWith("${widget._interfaceConnection.topic}/atts/map")) {
          print("map");
        }
        

        setState(() {
        //   for (MapEntry<String, dynamic> atts in jsonObject.entries) {
        //     for (MapEntry<String, dynamic> field in atts.value.entries) {
        //       // print('${atts.key} ${field.key} => ${field.value}');

        //       switch (atts.key) {
        //         case "measure":
        //           if (field.key == "value") {
        //             double updateVal = 0;
        //             switch (field.value.runtimeType) {
        //               case int:
        //                 updateVal = field.value.toDouble();
        //               case double:
        //                 updateVal = field.value;
        //             }
        //             setState(() {
        //               _value = updateVal;
        //             });
        //           }

        //           if (field.key == "decimals") {
        //             switch (field.value.runtimeType) {
        //               case int:
        //                 _measureDecimal = field.value;
        //               case double:
        //                 _measureDecimal = (field.value as double).toInt();
        //             }
        //           }
        //           break;
        //       }
        //     }
        //   }
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

    // _freqController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    mqttSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: cardHeadLine(widget._interfaceConnection),
    );
  }
}
