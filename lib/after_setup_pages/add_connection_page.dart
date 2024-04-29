import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/discovery_page.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/manual_connection_page.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/setup_pages/cloud_config_auth_page.dart';

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
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.1,
                height: MediaQuery.sizeOf(context).height / 5,
                child: TextButton(
                  style: ButtonStyle (
                    backgroundColor: MaterialStateProperty.all<Color>(black)
                  ),
                  onPressed: () {
                    // go to manual connection
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualConnectionPage(
                          ip: "",
                          port: ""
                        ),
                      ),
                    );
                  },
                  child: AutoSizeText(
                    "Manual broker",
                    style: TextStyle(
                      fontSize: 20,
                      color: white
                    ),
                    maxLines: 1,
                  )
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 13
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.1,
                height: MediaQuery.sizeOf(context).height / 5,
                child: TextButton(
                  style: ButtonStyle (
                    backgroundColor: MaterialStateProperty.all<Color>(black)
                  ),
                  onPressed: () {
                    // go to discovery page 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiscoveryPage(),
                      ),
                    );
                  },
                  child: AutoSizeText(
                    "Local discovery",
                    style: TextStyle(
                      fontSize: 20,
                      color: white
                    ),
                    maxLines: 1,
                  )
                ),
              )
            ],
        ),
      ),
    );
  }
}