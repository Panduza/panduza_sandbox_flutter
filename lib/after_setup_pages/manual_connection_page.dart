import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/add_connection_form.dart';

import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';

// Page to add a new connection manually

class ManualConnectionPage extends StatelessWidget {
  const ManualConnectionPage({
    super.key,
    this.name = "",
    this.ip = "",  
    this.port = "", 
  });

  final String name;
  final String ip;
  final String port;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Manual connection"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AddConnectionForm(
              name: name,
              ip: ip, 
              port: port
            )
          ],
        ),
      ),
    );
  }
}