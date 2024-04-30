import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/discovery_page.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/manual_connection_page.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';

// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud

class AddConnectionPage extends StatelessWidget {
  const AddConnectionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add self-managed broker"),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getTransitionButton(context, const ManualConnectionPage(), manualAddBrokerInfo, "Manual broker"),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 13
              ),
              getTransitionButton(context, const DiscoveryPage(), localDiscoveryInfo, "Local discovery")
            ],
        ),
      ),
    );
  }
}