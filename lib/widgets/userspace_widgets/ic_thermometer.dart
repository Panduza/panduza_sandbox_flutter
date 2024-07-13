import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'templates.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'package:mqtt_client/mqtt_client.dart';


class IcThermometer extends StatefulWidget {
  const IcThermometer(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcThermometer> createState() => _IcThermometerState();
}

class _IcThermometerState extends State<IcThermometer> {

  int _measureDecimal = 1;
  double _value = 0;
  
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? mqttSubscription;

  /// Init each value of the thermometer, here just the measure 
  /// temperature
  /// 
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {

    //
    if (c[0].topic.startsWith(widget._interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c[0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt);
      
        for (MapEntry<String, dynamic> atts in jsonObject.entries) {
          for (MapEntry<String, dynamic> field in atts.value.entries) {

            switch (atts.key) {
              case "measure":
                if (field.key == "value") {
                  double updateVal = 0;
                  switch (field.value.runtimeType) {
                    case int:
                      updateVal = field.value.toDouble();
                    case double:
                      updateVal = field.value;
                  }
                  setState(() {
                    _value = updateVal;
                  });
                }

                if (field.key == "decimals") {
                  switch (field.value.runtimeType) {
                    case int:
                      _measureDecimal = field.value;
                    case double:
                      _measureDecimal = (field.value as double).toInt();
                  }
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

    mqttSubscription = widget._interfaceConnection.client.updates!.listen(onMqttMessage);

    String attsTopic = "${widget._interfaceConnection.topic}/atts/#";
    // print(attsTopic);
    widget._interfaceConnection.client
        .subscribe(attsTopic, MqttQos.atLeastOnce);

  }

  late TextEditingController _freqController;

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
    mqttSubscription!.cancel();
    super.dispose();
  }

  /// Appearance of the widget 
  ///
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          cardHeadLine(widget._interfaceConnection),
          Text(
            "${double.parse(_value.toStringAsFixed(_measureDecimal))} °C",
            style: TextStyle(
              color: black
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                child: TextField(
                  textDirection: TextDirection.rtl,
                  controller: _freqController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(
                    color: black,
                    fontSize: 13
                  ),
                )
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "read per sec",
                style: TextStyle(
                  color: black
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      )
    );
  }
}
