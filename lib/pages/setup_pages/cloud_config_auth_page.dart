import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/cloud_auth_form.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/appBar.dart';

// Page to create the first account 

class CloudAuthPage extends StatelessWidget {

  const CloudAuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Cloud authentification"),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CloudAuthForm()
          ],
        ),
      ),
    );
  }
}