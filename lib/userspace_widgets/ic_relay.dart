import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/templates.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';

class IcRelay extends StatefulWidget {
  const IcRelay(this._interfaceConnection, {
    super.key
  });

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcRelay> createState() => _IcRelayState();
}

class _IcRelayState extends State<IcRelay> {
  bool? _enableValueReq = false;
  bool? _enableValueEff = false;

  ///
  ///
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    print("============");
    print('Received ${c[0].topic} from ${widget._interfaceConnection.topic} ');
    
    print(widget._interfaceConnection.topic);

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

              if (field.key == "open") {
                _enableValueEff = field.value;
                
                if (_enableValueEff != null) {
                  _enableValueReq = _enableValueEff;
                }
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
  
  /// When Switch tap send a mqtt request to the platform
  ///
  void Function(bool)? enableValueSwitchOnChanged() {
    
    if (_enableValueReq != _enableValueEff) {
      return null;
    } else {
      return (value) {
        enableValueToggleRequest();
      };
    }
  }

  /// Publish a request to make the relay take the value of the switch widget
  ///
  void enableValueToggleRequest() {
    if (_enableValueEff == null) {
      return;
    }
    bool target = _enableValueEff! ? false : true;

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

    // Example JSON object
    Map<String, dynamic> data = {
      "state": {"open": target}
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

  /// Simple widget of 
  ///
  @override
  Widget build(BuildContext context) {
    if (_enableValueEff != null) {
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardHeadLine(widget._interfaceConnection),
            Switch(
              value: _enableValueEff!,
              onChanged: enableValueSwitchOnChanged(),
              activeColor: blue,
            ),
            /*
            Switch(
              value: _enableValueEff, 
              onChanged: (value) {
              },
            )
            */
          ],
        )
      );
    } else {
      return const Card();
    }
  }
}