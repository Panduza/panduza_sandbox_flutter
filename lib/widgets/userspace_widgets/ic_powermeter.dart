import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/attribute_req_eff.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/attributes_state.dart';
import 'package:panduza_sandbox_flutter/widgets/userspace_widgets/basic_widget.dart';
import 'templates.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';


class IcPowermeter extends StatefulWidget {
  const IcPowermeter(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcPowermeter> createState() => _IcPowermeterState();
}

class _IcPowermeterState extends BasicWidget<IcPowermeter> {

  // I will have a map who where the key represent the attribute name, 
  // and the value is a map who represent every fields of this attribute 
  // Each field with have a value and a type associated

  final Map<String, Map<String, AttributeReqEff>> attributesNames = {
    "measure": {
      "value": AttributeReqEff(0, 0, double),
      "decimals": AttributeReqEff(3, 3, int)
    }
  };
  
  AttributesState? attributeState;
  late TextEditingController _freqController;

  /// Perform MQTT Subscriptions at the start of the component
  ///
  @override
  void initState() {
    super.initState();
    
    attributeState = AttributesState(widget._interfaceConnection, attributesNames, this);
    attributeState?.init();
    _freqController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    attributeState?.cancel();
    super.dispose();
  }

  /// Appearance of the powermeter widget
  ///
  @override
  Widget build(BuildContext context) {

    dynamic measureValue = attributeState?.getAttributeEffective("measure", "value");
    dynamic decimals = attributeState?.getAttributeEffective("measure", "decimals");

    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cardHeadLine(widget._interfaceConnection),
        Text(
          formatValueInBaseMilliMicro(double.parse(measureValue.toStringAsFixed(
            decimals
          )), "", "W"),
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
    ));
  }
}
