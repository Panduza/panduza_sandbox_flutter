import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/add_connection_page.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/connections_page.dart';
import 'package:panduza_sandbox_flutter/forms/add_connection_form.dart';
import 'package:panduza_sandbox_flutter/setup_pages/cloud_config_auth_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';

// Page to give the choice between use the panduza cloud or 
// use a broker the user has himself init (self-managed broker)

class AddCloudOrSelfManaged extends StatelessWidget {

  const AddCloudOrSelfManaged({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add self-mangaged broker or use cloud ?"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getTransitionButton(context, const CloudAuthPage(), panduzaCloudInfo, 'Panduza Cloud'),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 13
            ),
            getTransitionButton(context, const AddConnectionPage(), selfManagedBrokerInfo, 'Self-Managed Broker')
          ],
        ),
      )
    );
  }
}