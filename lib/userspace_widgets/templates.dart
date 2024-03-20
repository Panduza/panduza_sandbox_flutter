import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

Widget cardHeadLine(InterfaceConnection ic, bool isEdit, 
  {SharedPreferences? prefs, String? deviceName, Function? editSetState}) {
  if (isEdit) {
    return ListTile(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${ic.getType()} ${ic.getInterfaceName()}" ,
              style: TextStyle(
                color: white,
                fontSize: 14
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                if (prefs != null && deviceName != null) {
                  List<String>? interfaces = prefs.getStringList(deviceName);
                
                  if (interfaces != null) {
                    interfaces.remove(ic.getInterfaceName());
                    await prefs.setStringList(deviceName, interfaces);
                    (editSetState as Function).call();
                  }
                }
                
              },
              icon: Icon(
                Icons.delete,
                color: white
              ),
            )
          ],
        )
      )
    );
  }
  return ListTile(
    title: Center(
      child: Text(
        "${ic.getType()} ${ic.getInterfaceName()}" ,
        style: TextStyle(
          color: white,
          fontSize: 14
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

