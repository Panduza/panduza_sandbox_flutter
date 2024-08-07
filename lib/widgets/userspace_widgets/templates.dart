import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/utils/const.dart';

import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';

Widget cardHeadLine(InterfaceConnection ic) {
  return ListTile(
      title: Text(ic.getDeviceName()),
      subtitle: Row(children: [
        Text(ic.getType(),
            style: const TextStyle(
                color: Color.fromARGB(255, 0, 9, 27), fontSize: 12)),
        const Text("  ",
            style: TextStyle(
                color: Color.fromARGB(255, 66, 66, 66), fontSize: 12)),
        Text(ic.getInterfaceName(),
            style: const TextStyle(color: Colors.deepOrangeAccent, fontSize: 12)),
      ]));
}

// Template of title user widget, showing name 
// of the device, name of the type of interface 
// and the topic mqtt where it's stored
Widget cardHeadLine2(InterfaceConnection ic) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 5,
      horizontal: 15
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ic.getDeviceName(),
          style: TextStyle(
            color: black,
            fontSize: 20
          ),
        ),
        Row(
          children: [
            Text(ic.getType(),
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 9, 27), fontSize: 12)),
            const Text("  ",
                style: TextStyle(
                    color: Color.fromARGB(255, 66, 66, 66), fontSize: 12)),
            Text(ic.getInterfaceName(),
                style: const TextStyle(color: Colors.deepOrangeAccent, fontSize: 12)),
          ]
        )
      ]
    )
  );
  
 
}