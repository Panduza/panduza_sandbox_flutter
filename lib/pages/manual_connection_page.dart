import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/add_connection_form.dart';

import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';

// Page to add a broker connection on the disk, you need to give name,
// ip and port to add it

class ManualConnectionPage extends StatelessWidget {
  const ManualConnectionPage({
    super.key,
    required this.ip, 
    required this.port, 
  });

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
              ip: ip, 
              port: port
            )
          ],
        ),
      ),
    );
  }
}