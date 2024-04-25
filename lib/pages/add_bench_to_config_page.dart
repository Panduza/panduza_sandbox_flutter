import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/forms/add_bench_to_config_form.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';

// Page to create the first account 

class AddBenchToConfigPage extends StatelessWidget {

  const AddBenchToConfigPage({
    super.key,
    required this.token
  });

  final String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add bench to config"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AddBenchToConfigForm(
              token: token,
            )
          ],
        ),
      ),
    );
  }
}