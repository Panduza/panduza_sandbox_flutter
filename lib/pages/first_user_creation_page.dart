import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/first_user_creation_form.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';

// Page to create the first account 

class FirstUserCreationPage extends StatelessWidget {

  const FirstUserCreationPage({
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
      appBar: getAppBar("First user creation account"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FirstUserCreationForm(
              ip: hostIp,
              port: port,
            )
          ],
        ),
      ),
    );
  }
}