import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/attribute_req_eff.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/attributes_state.dart';
import 'package:panduza_sandbox_flutter/widgets/userspace_widgets/basic_widget.dart';
import 'templates.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';

class IcBlc extends StatefulWidget {
  const IcBlc(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcBlc> createState() => _IcBlcState();
   
}

class _IcBlcState extends BasicWidget<IcBlc> {

  // List of possible attributes mqtt
  final Map<String, Map<String, AttributeReqEff>> attributesNames = {
    "enable": {
      "value": AttributeReqEff(null, null, bool),
    },
    "analog_modulation": {
      "value": AttributeReqEff(null, null, bool)
    },
    "mode": {
      "value": AttributeReqEff(null, null, String)
    },
    "power": {
      "value": AttributeReqEff(null, null, double, true),
      "min": AttributeReqEff(null, null, double),
      "max": AttributeReqEff(null, null, double),
      "decimals": AttributeReqEff(null, null, int)
    },
    "current": {
      "value": AttributeReqEff(null, null, double),
      "min": AttributeReqEff(null, null, double),
      "max": AttributeReqEff(null, null, double),
      "decimals": AttributeReqEff(null, null, int)
    }
  };

  AttributesState? attributesState;

  // If request made on the slider apply it after a small timer
  bool isRequestingPower = false;
  List<double> powerRequests = [];

  bool isRequestingCurrent = false;
  List<double> currentRequests = [];


  /// Perform MQTT Subscriptions at the start of the component
  ///
  @override
  void initState() {
    super.initState();
    
    attributesState = AttributesState(widget._interfaceConnection, attributesNames, this);
    attributesState?.init();
  }

  @override
  void dispose() {
    attributesState?.cancel();
    super.dispose();
  }

  // Return List<Widget> with different part of the widget to show when
  // power attribute has been received 

  List<Widget> powerWidgetPart() {
    List<Widget> partOfWidget = [];

    partOfWidget.add(
      const SizedBox(
        height: 20,
      )
    );

    // Show power in percentage and the value in W

    partOfWidget.add(
      Text(
        'Power : ${double.parse(((attributesState?.getAttributeRequested("power", "value") as double) / 
          (attributesState?.getAttributeRequested("power", "max") as double) * 100).toStringAsFixed(
            (attributesState?.getAttributeRequested("power", "decimals") as int)
        ))}% (${formatValueInBaseMilliMicro(double.parse((attributesState?.getAttributeRequested("power", "value") as double).toStringAsFixed(
          (attributesState?.getAttributeRequested("power", "decimals") as int)
        )), "", "W")})',
        style: TextStyle(
          color: black
        ),
      ),
    );

    partOfWidget.add(
      Slider(
        value: attributesState?.getAttributeEffective("power", "value"),
        onChanged: (value) {
          setState(() {
            attributesState?.setAttributeRequested("power", "value", 
              double.parse((value).toStringAsFixed(
                attributesState?.getAttributeRequested("power", "decimals")
              ))
            );

            attributesState?.sendAttributeWithTimer("power", "value", attributesState?.getAttributeRequested("power", "value"));
          });
        },
        min: 0,
        max: attributesState?.getAttributeEffective("power", "max"),
      )
    );

    return partOfWidget;
  }


  // Return List<Widget> with different part of the widget to show when
  // current attribute has been received 

  List<Widget> currentWidgetPart() {
    List<Widget> partOfWidget = [];

    partOfWidget.add(
      const SizedBox(
        height: 20,
      )
    );

    partOfWidget.add(
      Text(
        formatValueInBaseMilliMicro(double.parse(attributesState?.getAttributeEffective("current", "value").toStringAsFixed(
          attributesState?.getAttributeEffective("current", "decimals") 
        )), "Current : ", "A"),
        style: TextStyle(
          color: black
        ),
      )
    );
    
    partOfWidget.add(
      Slider(
        value: attributesState?.getAttributeRequested("current", "value"),
        onChanged: (value) {
          setState(() {
            attributesState?.setAttributeRequested("current", "value", 
              double.parse((value).toStringAsFixed(
                attributesState?.getAttributeEffective("current", "decimals")
              ))
            );
            attributesState?.sendAttributeWithTimer("current", "value", attributesState?.getAttributeRequested("current", "value"));
          });
        },
        min: attributesState?.getAttributeEffective("current", "min"),
        max: attributesState?.getAttributeEffective("current", "max"),
      )
    );

    return partOfWidget;
  }

  @override
  Widget build(BuildContext context) {    

    // Here add each part used by the widget (for example could only used 
    // enable attribute and so show only the button turn on/off)
    List<Widget> firstRowContent = [];
    List<Widget> partOfWidget = [];

    // If analog modulation attribute is activated, you can 
    // send request and laser can actually respond to it 
    if (attributesState?.getAttributeEffective("analog_modulation", "value") != null) {
      
      // Show a red button to desactivated analog modulation
      // or a green to reactivate it (if analog button off must
      // hide every other part of the widget)
      if (attributesState?.getAttributeEffective("analog_modulation", "value")!) {
        firstRowContent.add(
          const Spacer()
        );
        firstRowContent.add(
          Column(
            children: [
              OutlinedButton(
                onPressed: () => {
                  attributesState?.setAttributeRequested("analog_modulation", "value", false),
                  attributesState?.sendAnyAttribute("analog_modulation", "value")
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red
                  ),
                  foregroundColor:Colors.red,
                  shape: const CircleBorder()
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
              Text(
                "Analog modulation",
                style: TextStyle(
                  fontSize: 10,
                  color: black
                ),
              )
            ],
          )
        );
      } else {
        firstRowContent.add(
          Column(
            children: [
              OutlinedButton(
                onPressed: () => {
                  attributesState?.setAttributeRequested("analog_modulation", "value", true),
                  attributesState?.sendAnyAttribute("analog_modulation", "value")
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.green
                  ),
                  foregroundColor:Colors.green,
                  shape: const CircleBorder()
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ),
              Text(
                "Analog modulation",
                style: TextStyle(
                  fontSize: 10,
                  color: black
                ),
              )
            ],
          )
        );
      }
    }
    
    // If analog modulation is not used or it is activated by interface, command 
    // can be actually send and be treated by laser
    if (attributesState?.getAttributeEffective("analog_modulation", "value") == null || 
        attributesState?.getAttributeEffective("analog_modulation", "value") == true) {
       // If enable attribute is received show a turn on/off button
      if (attributesState?.getAttributeEffective("enable", "value") != null) {
        firstRowContent.insert(
          0,
          Column(
            children: [
              Switch(
                value: attributesState?.getAttributeEffective("enable", "value"),
                onChanged: (value) {
                  setState(() {
                    attributesState?.setAttributeRequested("enable", "value", value);
                    attributesState?.sendAnyAttribute("enable", "value");
                  });
                } 
              ),
              Text(
                "On/Off",
                style: TextStyle(
                  fontSize: 10,
                  color: black
                ),
              )
            ],
          )
        );
      }

      // If mode, current and voltage attributes are given, 
      // show dropdown button to make it controle the laser 
      // with power or current, but if one attribute is missing 
      // even if mode is given don't show this choice (because 
      // if for example mode and power are given, there is no use to show a
      // current mode button)
      if (attributesState?.getAttributeEffective("mode", "value") != null && 
        attributesState?.getAttributeEffective("current", "value") != null &&
        attributesState?.getAttributeEffective("power", "value") != null) {
        partOfWidget.add(
          const SizedBox(
            height: 10,
          )
        );
        partOfWidget.add(
          DropdownButton<String> (
            items: const [
              DropdownMenuItem<String>(
                value: "constant_power",
                child: Text("power mode"),
              ),
              DropdownMenuItem<String>(
                value: "constant_current",
                child: Text("current mode"),
              )
            ],
            value: attributesState?.getAttributeRequested("mode", "value"),
            onChanged: (String? value) {
              setState(() {
                attributesState?.setAttributeRequested("mode", "value", value);
                attributesState?.sendAnyAttribute("mode", "value");
              });
            }
          )
        );

        if (attributesState?.getAttributeRequested("mode", "value") == "constant_power") {
          partOfWidget.addAll(
            powerWidgetPart()
          );
        } else {
          partOfWidget.addAll(
            currentWidgetPart()
          );
        }

      } else if (attributesState?.getAttributeEffective("power", "value") != null) {
        partOfWidget.addAll(
          powerWidgetPart()
        );
      } else if (attributesState?.getAttributeRequested("current", "value") != null) {
        partOfWidget.addAll(
          currentWidgetPart()
        );
      }
      
      if (partOfWidget.isEmpty && firstRowContent.isEmpty) {
        return Card(
          child: Column(
            children: [
              cardHeadLine(widget._interfaceConnection),
              Text(
                "Wait for data...",
                style: TextStyle(
                  color: black
                ),
              )
            ]
          )
        );
      }
    }

   

    // Add title at the start of the widget
    firstRowContent.insert(0, cardHeadLine2(widget._interfaceConnection));
    partOfWidget.insert(0, Row(
      children: firstRowContent,
    ));

    return Card(
      child: Column(
        children: partOfWidget,
      ),
    );
  }
}
