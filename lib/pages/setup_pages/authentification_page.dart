import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/authentification_form.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/appBar.dart';

// Page to authentificate to a broker

class AuthentificationPage extends StatelessWidget {

  // Maybe show the platform name to the user could be a good idea
  const AuthentificationPage({
    super.key,
    required this.hostIp,
    required this.port
  });

  final String hostIp;
  final String port;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Authentification"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AuthentificationForm(
              ip: hostIp,
              port: port,
            )
          ],
        ),
      ),
    );
  }
}