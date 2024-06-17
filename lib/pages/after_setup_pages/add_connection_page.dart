import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/discovery_page.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/manual_connection_page.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/utils_widgets.dart';

// Page with the 2 choices of adding connection :
// with manual input, with discovery

class AddConnectionPage extends StatelessWidget {
  const AddConnectionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add self-managed broker"),
      body: getBasicLayoutDynamic(
        context,
        page: const ManualConnectionPage(),
        title: "Add broker manually",
        icon:  Icons.keyboard_outlined,
        buttonLabel: "Add my broker",
        description: manualAddBrokerInfo,

        page2: const DiscoveryPage(), 
        title2: "Local discovery broker",
        icon2: Icons.wifi_find_outlined,
        buttonLabel2: "Discover my brokers",
        description2: localDiscoveryInfo
      )
    );
  } 
}