import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/data/company.dart';

import 'package:panduza_sandbox_flutter/forms/add_device_to_bench_form.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/forms/add_device_to_bench_form.dart';
import 'package:panduza_sandbox_flutter/forms/create_first_account_cloud_form.dart';

// Page to create the first account 

class CreateFirstAccountCloudPage extends StatelessWidget {

  const CreateFirstAccountCloudPage({
    super.key,
    required this.token,
    required this.company
  });

  final String token;
  final Company company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Create first cloud account"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FirstUserCreationCloudForm(
              token: token,
              company: company,
            )
          ],
        ),
      ),
    );
  }
}