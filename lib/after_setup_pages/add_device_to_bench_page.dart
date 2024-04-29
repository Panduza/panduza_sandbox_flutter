import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/forms/add_device_to_bench_form.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/forms/add_device_to_bench_form.dart';

// Page to create the first account 

class AddDeviceToBenchPage extends StatelessWidget {

  const AddDeviceToBenchPage({
    super.key,
    required this.token,
    required this.benchId
  });

  final String token;
  final int benchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add device in a bench config"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AddDeviceToBenchForm(
              token: token,
              benchId: benchId,
            )
          ],
        ),
      ),
    );
  }
}