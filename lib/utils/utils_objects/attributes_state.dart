import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/attribute_req_eff.dart';
import 'package:panduza_sandbox_flutter/widgets/userspace_widgets/basic_widget.dart';
import 'interface_connection.dart';

/// List of attribute manage by userspace widget
///
class AttributesState {
  // Info of connection mqtt
  InterfaceConnection interfaceConnection;

  // Every attributes name of this interface on the broker
  // With requested value, effecyive value and type of the value
  final Map<String, Map<String, AttributeReqEff>> attributesNames;

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? mqttSubscription;

  List<Timer> timersToClose = [];

  // To be able to set state the widget
  BasicWidget widgetState;
  
  // Constructor
  AttributesState(this.interfaceConnection, this.attributesNames, this.widgetState);

  // Send String any attribute
  void sendAnyAttribute(String attributeName, String fieldName) {
    // Check if there is a need to update value or the broker 
    // has already the last state 
    if (attributesNames[attributeName]?[fieldName]?.requested != attributesNames[attributeName]?[fieldName]?.effective) {

      if (attributesNames[attributeName]?[fieldName]?.effective == null) {
        return;
      }

      dynamic target = attributesNames[attributeName]?[fieldName]?.requested!;

      basicSendingMqttRequest(attributeName, fieldName, target, interfaceConnection);
      attributesNames[attributeName]?[fieldName]?.requested = target;

      widgetState.callSetState();
    }
  }

  // Have a new map who link timer, list of request, and boolean 
  // of if a request is currently asked
  void sendAttributeWithTimer(String attributeName, String fieldName, dynamic valueToSend) {
    

    // Have a isRequesting variable inside of the map ?

    if (getAttributeEffective(attributeName, fieldName) != getAttributeRequested(attributeName, fieldName) && 
        getIsRequesting(attributeName, fieldName) == false) {
      // Not possible to request anymore before this sending has been made
      // User can change send value only every 50 milliseconds
      setIsRequesting(attributeName, fieldName, true);

      // Send power request to broker after 50 milliseconds to not 
      // send request while at each tick of the slider
      Timer timer = Timer(const Duration(milliseconds: 200), () {
        
        addRequest(attributeName, fieldName, valueToSend);
        basicSendingMqttRequest(attributeName, fieldName, valueToSend, interfaceConnection);

        // User can remake a another sending
        setIsRequesting(attributeName, fieldName, false);
      });

      timersToClose.add(timer);
    }
  }

  /// Init each value of the powermeter, here just the measure value
  /// powermeter
  /// 
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    // print("============");
    // print('Received ${c[0].topic} from ${widget._interfaceConnection.topic} ');

    if (c[0].topic.startsWith(interfaceConnection.topic)) {
      if (!c[0].topic.endsWith('/info')) {
        final recMess = c[0].payload as MqttPublishMessage;

        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        var jsonObject = json.decode(pt); 
        
        for (MapEntry<String, dynamic> atts in jsonObject.entries) {
          for (MapEntry<String, dynamic> field in atts.value.entries) {
            if (attributesNames.containsKey(atts.key)) {
              if (attributesNames[atts.key]!.containsKey(field.key)) {

                // Manage attribute 
                switch (attributesNames[atts.key]?[field.key]?.type) {

                  // If attribute field is supposed to be a int
                  case int:
                    switch (field.value.runtimeType) {
                      case int:
                        attributesNames[atts.key]![field.key] = AttributeReqEff(field.value, field.value, int);
                        break;
                      case double:
                        attributesNames[atts.key]![field.key] = AttributeReqEff((field.value as double).toInt(), (field.value as double).toInt(), int);
                        break;
                    }
                    break;
                  
                  // If attribute field is supposed to be a double
                  case double:
                    if (hasNoRequest(atts.key, field.key) == true || hasNoRequest(atts.key, field.key) == null) {
                      switch (field.value.runtimeType) {
                        case int:
                          attributesNames[atts.key]![field.key] = AttributeReqEff(field.value.toDouble(), field.value.toDouble(), double);
                          break;
                        
                        case double:
                          attributesNames[atts.key]![field.key] = AttributeReqEff(field.value, field.value, double);
                          break;
                      }
                      break;
                    } else {
                      removeRequest(atts.key, field.key);
                      if (hasNoRequest(atts.key, field.key) == true) {
                        switch (field.value.runtimeType) {
                          case int:
                            attributesNames[atts.key]![field.key] = AttributeReqEff(field.value.toDouble(), field.value.toDouble(), double);
                            break;
                          
                          case double:
                            attributesNames[atts.key]![field.key] = AttributeReqEff(field.value, field.value, double);
                            break;
                        }
                        break;
                      }
                    }
                    

                  // If attribute field is supposed to be a String
                  case String:
                    attributesNames[atts.key]![field.key] = AttributeReqEff(field.value, field.value, String);
                    break;

                  // If attribute filed is supposed to be a bool
                  case bool:
                    // print("${atts.key} | ${field.key} => ${field.value}");
                    attributesNames[atts.key]![field.key] = AttributeReqEff(field.value, field.value, bool);
                }
              }
            }
          }
        }
        widgetState.callSetState();
      }
    } else {
      // print('not good:');
    }
  }

  void initMqttSubscription() {
    mqttSubscription = interfaceConnection.client.updates!.listen(onMqttMessage);

    String attsTopic = "${interfaceConnection.topic}/atts/#";
    // print(attsTopic);
    interfaceConnection.client
        .subscribe(attsTopic, MqttQos.atLeastOnce);
  }

  void init() {
    Future.delayed(const Duration(milliseconds: 1), initMqttSubscription);
  } 

  // Get infos attributes
  dynamic getAttributeRequested(String attributeName, String fieldName) {
    return attributesNames[attributeName]?[fieldName]?.requested;
  }

  dynamic getAttributeEffective(String attributeName, String fieldName) {
    return attributesNames[attributeName]?[fieldName]?.effective;
  }

  bool getIsRequesting(String attributeName, String fieldName) {
    return attributesNames[attributeName]?[fieldName]?.isRequesting as bool;
  }

  // Set info attributes
  void setAttributeRequested(String attributeName, String fieldName, dynamic value) {
    attributesNames[attributeName]?[fieldName]?.requested = value;
  }

  void setAttributeEffective(String attributeName, String fieldName, dynamic value) {
    attributesNames[attributeName]?[fieldName]?.effective = value;
  }

  void setIsRequesting(String attributeName, String fieldName, bool value) {
    attributesNames[attributeName]?[fieldName]?.isRequesting = value;
  }

  void addRequest(String attributeName, String fieldName, dynamic value) {
    attributesNames[attributeName]?[fieldName]?.curRequests?.add(value);
  } 

  bool? hasNoRequest(String attributeName, String fieldName) {
    return attributesNames[attributeName]?[fieldName]?.curRequests?.isEmpty;
  } 

  void removeRequest(String attributeName, String fieldName) {
    attributesNames[attributeName]?[fieldName]?.curRequests?.removeAt(0);
  } 

  void cancel() {
    for (Timer timer in timersToClose) {
      timer.cancel;
    }
    mqttSubscription!.cancel();
  }
}

// pza/server/alien/test
