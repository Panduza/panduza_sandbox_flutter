import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udp/udp.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/manual_connection_page.dart';

late MqttServerClient _client;
bool _isConnecting = false;
final _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final Random _rnd = Random();


Future<SharedPreferences> getPreferences() async {
  return await SharedPreferences.getInstance();
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
    

    // print(pref.containsKey(connectionKey));

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

/*
  This class will go looking for different platform on the network sending 
  broadcast and getting an answer for each platform
*/

Future<List<(InternetAddress, int)>> platformDiscovery() async {

  List<(InternetAddress, int)> ipPort = []; 
  String waitedAnswer = '{"name": "panduza_platform","version": 1.0}';

  RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 63500);
  socket.broadcastEnabled = true;
    
  socket.listen((e) {
    Datagram? datagram = socket.receive();
    if (datagram != null) {
      String answer = String.fromCharCodes(datagram.data);
      
      // Here send the port of platform and not broker, how to get the port of the broker ? 
      if(answer == waitedAnswer) {
        if (!ipPort.contains((datagram.address, datagram.port))) ipPort.add((datagram.address, datagram.port));
      }
    }
  });

  socket.send(jsonEncode({"search" : true}).codeUnits, InternetAddress("255.255.255.255"), portLocalDiscovery);
  await Future.delayed(const Duration(milliseconds: 100));
  socket.close();

  return ipPort;
}


