import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';


// Card style

Widget basicCard(Widget child) {
  return Card(
    color: black,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: blue
      ),
      borderRadius: BorderRadius.circular(4.0)
    ),
    child: child
  );
  
}


// Card head content: type, name,  

Widget cardHeadLine(InterfaceConnection ic) {
  return ListTile(
    title: Center(
      child: Text(
        "${ic.getType()} ${ic.getInterfaceName()}" ,
        style: TextStyle(
          color: white,
          fontSize: 16
        ),
      ),
    )
    /*
    Row(
      children: [
        
        Text(
          "${ic.getDeviceName()} ${ic.getInterfaceName()}",
          style: TextStyle(
            color: white, 
            fontSize: 12)
          ),
        
        Text(
          "  ",
          style: TextStyle(
            color: white,
            fontSize: 12
          )
        ),
        Text(
          ic.getInterfaceName(),
          style: TextStyle(
            color: white, 
            fontSize: 12
          )
        ),
        
      ]
    )
    */
  );
}

