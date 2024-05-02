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
      body: getBasicLayoutDynamic(
        context,
        page: const CloudAuthPage(),
        title: "Panduza Cloud",
        icon: Icons.cloud_outlined,
        buttonLabel: "Connect",
        description: panduzaCloudInfo,

        page2: const AddConnectionPage(), 
        title2: "Self-Managed Broker",
        icon2: Icons.broadcast_on_personal_outlined,
        buttonLabel2: "Append",
        description2: selfManagedBrokerInfo
      )
    );
  }
}