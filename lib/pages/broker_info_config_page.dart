import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/data/company.dart';
import 'package:panduza_sandbox_flutter/forms/broker_info_form.dart';

// Page to create the first account 

class BrokerInfoConfigPage extends StatelessWidget {

  const BrokerInfoConfigPage({
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
      appBar: getAppBar("Cloud config authentification"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BrokerInfoConfigForm(
              token: token,
              company: company,
            )
          ],
        ),
      ),
    );
  }
}