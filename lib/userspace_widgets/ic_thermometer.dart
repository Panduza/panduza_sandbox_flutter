import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'templates.dart';
import '../../data/interface_connection.dart';

import 'dart:convert';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IcThermometer extends StatefulWidget {
  const IcThermometer(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  _IcThermometerState createState() => _IcThermometerState();
}

class _IcThermometerState extends State<IcThermometer> {

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

      
        for (MapEntry<String, dynamic> atts in jsonObject.entries) {
          for (MapEntry<String, dynamic> field in atts.value.entries) {
            print('${atts.key} ${field.key} => ${field.value}');

            switch (atts.key) {
              case "temperature":
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

                if (field.key == "decimals") {

                }
                break;
            }
          }
        }
        
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

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cardHeadLine(widget._interfaceConnection),
        Text(
          "${_value.toString()} °C",
          style: TextStyle(
            color: black
          ),
        ),
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
              )
            ),
            Text(
              "read per sec",
              style: TextStyle(
                color: black
              ),
            ),
          ],
        )
      ],
    ));
  }
}
