import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/cloud_config_auth_form.dart';
import 'package:panduza_sandbox_flutter/forms/first_user_creation_form.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/forms/authentification_form.dart';

// Page to create the first account 

class CloudConfigAuthPage extends StatelessWidget {

  const CloudConfigAuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Cloud config authentification"),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CloudConfigAuthForm()
          ],
        ),
      ),
    );
  }
}