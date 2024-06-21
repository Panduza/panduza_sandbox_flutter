import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';

late MqttServerClient _client;
bool _isConnecting = false;
final _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final Random _rnd = Random();

// remove the connection of disk, 
// first the direct entry of this connection 
// then remove it from the directory (connectionKey)
// if there no more connection remove the entry of the
// directory (connectionKey)
Future<void> removeConnection(String connectionName, String hostIp, String port) async {

  SharedPreferences pref = await SharedPreferences.getInstance();

  List<String> platformNames = pref.getStringList(connectionKey) as List<String>;

  int indexToRemove = platformNames.indexOf(connectionName);
  await pref.remove(connectionName);

  platformNames.remove(platformNames[indexToRemove]);
  await pref.setStringList(connectionKey, platformNames);

  if (platformNames.isEmpty) await pref.remove(connectionKey);
}

// Check If any connection already with this same name in the preferences (data on the disk)
Future<bool> checkIfConnectionNameExist(String newConnectionName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  // if any connection can't have a another connection with same name
  List<String>? connections = pref.getStringList(connectionKey);
  if (connections == null) {
    return false;
  }

  if (connections.contains(newConnectionName)) {
    return true;
  }

  return false;
}


// Check If any connection with the same ip/port already exist in the preferences 
// (data on the disk)
Future<bool> checkIfPortIpExist(String hostIp, String port) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  List<String>? connections = pref.getStringList(connectionKey);

  // if any connection can't have a another connection with same ip/port
  if (connections == null) {
    return false;
  }

  // Look for every connection if there is one with the same ip/port already existing
  for (String connectionName in connections) {
    List<String>? infoConnection = pref.getStringList(connectionName);
    // the information of the connection is supposed always exist while 
    // his name is stocked in the connection names list
    if (infoConnection == null) {
      continue;
    }
    if (infoConnection[1] == hostIp && infoConnection[2] == port) {
      return true;
    }
  }

  return false;
}

// Add a connection on the disk if the name hasn't been used

Future<void> addConnection(String name, String hostIp, 
  String port, bool isCloud) async {

  SharedPreferences pref = await SharedPreferences.getInstance();
  Object? newCollection = pref.get(name);

  if (newCollection == null) {
    if (isCloud) {
      pref.setStringList(name, [name, hostIp, port, "1"]);
    } else {
      pref.setStringList(name, [name, hostIp, port, "0"]);
    }

    if (pref.containsKey(connectionKey) == false) {
      await pref.setStringList(connectionKey, [name]);
    } else {
      List<String>? oldConnectionNames = pref.getStringList(connectionKey);
      List<String> noNulConnectionNames = oldConnectionNames as List<String>;
      List<String> newConnectionNames = List.from([name])..addAll(noNulConnectionNames);
      await pref.setStringList(connectionKey, newConnectionNames);
    }

  } else {
    // TO DO : Give a error to the user, name already used
  }
}

// Edit the existing connection having this name on the disk
Future<void> editConnection(String oldName, String newName, String hostIp, 
  String port, bool isCloud) async {

  SharedPreferences pref = await SharedPreferences.getInstance();

  pref.remove(oldName);
  if (isCloud) {
    pref.setStringList(newName, [newName, hostIp, port, "1"]);
  } else {
    pref.setStringList(newName, [newName, hostIp, port, "0"]);
  }
  

  List<String>? platformNames = pref.getStringList(connectionKey);
  if (platformNames != null) {
    platformNames.remove(oldName);
    platformNames.add(newName);
    await pref.setStringList(connectionKey, platformNames);
  } 

  // This case should never happen because the connection we are currently
  // editing exist (so there at least this connection inside of directory
  // value of connectionKey)
}
 

// get every connections existing on the disk
/*
Future<void> getConnections() async {

  SharedPreferences pref = await getPreferences();
  pref.getStringList(connectionKey);
  // return pref.getStringList(connectionKey);
}
*/

// entry point to mqtt

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String generateRandomMqttIdentifier() {
  String test = getRandomString(15);
  // print(test);
  return test;
}


// Try connecting to the broker mqtt, if succes return the client
// else return null  

Future<MqttServerClient?> tryConnecting(String host, String portStr, String username, String password) async {

  if (!_isConnecting) {
    _isConnecting = true;
    try {
      
      int port = int.parse(portStr);


      _client = MqttServerClient.withPort(
          host, generateRandomMqttIdentifier(), port);
      _client.setProtocolV311();

      _client.keepAlivePeriod = 20;

      await _client.connect(username, password);

      _client.onConnected = () {
        print("MQTT connected");
      };

      _isConnecting = false;
      return _client;
    } catch (error) {
      print(error);

      _isConnecting = false;
      if (Platform.isAndroid || Platform.isIOS) {
        Fluttertoast.showToast(
          msg: "Connection failed",
          textColor: Colors.black,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG
        );
      }
      
      // never return because _client not init
      return null;
    }
  }

  if (Platform.isAndroid || Platform.isIOS) {
     Fluttertoast.showToast(
      msg: "A connection is already in process",
      textColor: Colors.black,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG
    );
  }
 
  
  return null;
}

// If user mistake show a pop up to describe his mistake with 
// a okay button to make it dissapear
void showMyDialogError(BuildContext context, String textError) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(textError),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      );
    }
  );
}

// If any field is empty show a error 
Future<bool> checkIfConnectionValid(BuildContext context, String name, String hostIp, String port) async {

  if (name.isEmpty || hostIp.isEmpty || port.isEmpty) {
    showMyDialogError(context, "A field is empty, you need to fill them all");
    return false;
  }
  
  // Check if the port is a number 
  if (int.tryParse(port) == null) {
    showMyDialogError(context, "Port need to be a number");
    return false;
  }

  // Check if the port has a value of uint16
  if (int.parse(port) < 0 || int.parse(port) > 65535) {
    showMyDialogError(context, "Port need to a correct value (0 to 65535)");
    return false;
  }

  // Check If any connection already with this same name
  if (await checkIfConnectionNameExist(name)) {
    showMyDialogError(context, "This connection name already exist");
    return false;
  }

  // Check If any connection with the same ip/port already exist
  if (await checkIfPortIpExist(hostIp, port)) {
    showMyDialogError(context, "The ip/port combination is already in use for another connection");
    return false;
  }

  return true;
}

// Convert dynamic to double if possible
double valueToDouble(dynamic value) {
  switch (value.runtimeType) {
    case int:
      return value.toDouble();
    case double:
      return value;
  }
  return 0.0;
}