import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

// Add a connection on the disk if the name hasn't been used

String connectionKey = "connectionName";

Future<SharedPreferences> getPreferences() async {
  return await SharedPreferences.getInstance();
}

Future<void> addConnection(String name, String hostIp, 
  String port) async {

  SharedPreferences pref = await SharedPreferences.getInstance();
  Object? newCollection = pref.get(name);

  if (newCollection != Null) {
    pref.setStringList(name, [name, hostIp, port]);

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


// get every connections existing on the disk

Future<void> getConnections() async {

  SharedPreferences pref = await getPreferences();
  // return pref.getStringList(connectionKey);
}