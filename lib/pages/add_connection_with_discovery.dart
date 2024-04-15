import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/add_connection_form.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';


// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud

class ManualConnectionPage extends StatelessWidget {
  
  const ManualConnectionPage({
    super.key,
    required this.ip,
    required this.port
  });

  final String ip;
  final String port;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add connection"),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[AddConnectionForm(
              ip: ip,
              port: port,
            )],
        ),
      ),
    );
  }
}
