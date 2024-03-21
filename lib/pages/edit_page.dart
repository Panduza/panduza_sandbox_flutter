import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/edit_connection_form.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';

// Page who will call the form to edit a connection 
// (change ip, port or name of a broker connection)

class EditPage extends StatelessWidget {
  const EditPage({
    super.key,
    required this.platformName,
    required this.hostIp,
    required this.port
  });

  final String platformName;
  final String hostIp;
  final String port;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Edit connection"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EditConnectionForm(
              platformName: platformName,
              hostIp: hostIp,
              port: port,
            )
          ],
        ),
      ),
    );
  }
}