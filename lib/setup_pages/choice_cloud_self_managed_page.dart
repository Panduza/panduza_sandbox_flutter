import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/add_connection_page.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/connections_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/setup_pages/cloud_config_auth_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';

// Page to give the choice between use the panduza cloud or 
// use a broker the user has himself init

class ChoiceCloudSelfManagedPage extends StatelessWidget {

  const ChoiceCloudSelfManagedPage({
    super.key,
    required this.prefs 
  });

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {

    if (!(prefs.containsKey(connectionKey))) {
      return Scaffold(
        // bar at the top of the application
        appBar: getAppBar("Use Self-Managed broker or Cloud ?"),
        // If a connection has already been created send on the connections page
        // (the user can see the already add connection) when self-managed broker button tap
        
        // get the button to go to the login page of cloud 
        // with info icon to get the information giving details
        // on what the cloud can currently offer 

        // get the button to go to the page to add a self managed
        // broker or if a connection already exist go to the connections page 
        // with a info icon to precise what is a self managed broker 
        body:  getBasicLayoutDynamic(
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
        ),
      );
    } else {

      // If a connection has already been created send on the connections page
      // (the user can see the already add connection) when self-managed broker button tap

      // get the button to go to the login page of cloud 
      // with info icon to get the information giving details
      // on what the cloud can currently offer 

      // get the button to go to the page to add a self managed
      // broker or if a connection already exist go to the connections page 
      // with a info icon to precise what is a self managed broker 
      return Scaffold(
        // bar at the top of the application
        appBar: getAppBar("Use Self-Managed broker or Cloud ?"),
        body: getBasicLayoutDynamic(
          context,
          page: const CloudAuthPage(),
          title: "Panduza Cloud",
          icon: Icons.cloud_outlined,
          buttonLabel: "Connect",
          description: panduzaCloudInfo,

          page2: const ConnectionsPage(), 
          title2: "Self-Managed Broker",
          icon2: Icons.broadcast_on_personal_outlined,
          buttonLabel2: "Append",
          description2: selfManagedBrokerInfo
        ),
      );
    }
  }
}