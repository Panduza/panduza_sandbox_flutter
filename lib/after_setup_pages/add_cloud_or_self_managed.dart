import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/add_connection_page.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/setup_pages/cloud_config_auth_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';

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
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.1,
              height: MediaQuery.sizeOf(context).height / 5,
              child: TextButton(
                style: ButtonStyle (
                  backgroundColor: MaterialStateProperty.all<Color>(black)
                ),
                onPressed: () {
                  // Go to cloud Authentification page
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const CloudAuthPage())
                  );
                },
                child: AutoSizeText(
                  'Panduza Cloud',
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
                  // Go to cloud Local discovery page (with option to activate manual broker info)
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const AddConnectionPage())
                  );
                },
                child: AutoSizeText(
                  'Self-Managed Broker',
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
      )
    );
  }
}