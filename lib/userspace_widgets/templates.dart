import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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


// basic card head content: type, name and if we are in edit page 
// also show a edit and remove button on these interfaces 

Widget cardHeadLine(InterfaceConnection ic, bool isEdit, 
  {SharedPreferences? prefs, String? deviceName, Function? editSetState}) {
  if (isEdit) {
    return ListTile(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              "${ic.getType()} ${ic.getInterfaceName()}" ,
              style: TextStyle(
                color: white,
                fontSize: 14
              ),
              maxLines: 1,
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
      child: AutoSizeText(
        "${ic.getType()} ${ic.getInterfaceName()}" ,
        style: TextStyle(
          color: white,
          fontSize: 12
        ),
        maxLines: 2,
      ),
    )
  );
}

