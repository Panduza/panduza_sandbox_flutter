import 'package:flutter/material.dart';
import '../../data/interface_connection.dart';

Widget cardHeadLine(InterfaceConnection ic) {
  return ListTile(
      title: Text(ic.getType()),
      subtitle: Row(children: [
        Text(ic.getDeviceName(),
            style: const TextStyle(
                color: Color.fromARGB(255, 0, 9, 27), fontSize: 12)),
        const Text("  ",
            style: TextStyle(
                color: Color.fromARGB(255, 66, 66, 66), fontSize: 12)),
        Text(ic.getInterfaceName(),
            style: const TextStyle(color: Colors.orange, fontSize: 12)),
      ]));
}
