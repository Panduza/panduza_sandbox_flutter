import 'dart:async';
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


class IcThermometer extends StatefulWidget {
  const IcThermometer(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcThermometer> createState() => _IcThermometerState();
}

class _IcThermometerState extends BasicWidget<IcThermometer> {

  // I will have a map who where the key represent the attribute name, 
  // and the value is a map who represent every fields of this attribute 
  // Each field with have a value and a type associated

  final Map<String, Map<String, AttributeReqEff>> attributesNames = {
    "measure": {
      "value": AttributeReqEff(double),
      "decimals": AttributeReqEff(int)
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

    _freqController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    attributeState?.cancel();
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
            "${double.parse(attributeState?.getAttributeEffective("measure", "value").toStringAsFixed(
              attributeState?.getAttributeEffective("measure", "decimals")
            ))} °C",
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
