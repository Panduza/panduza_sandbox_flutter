import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/data/company.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/pages/broker_info_config_page.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';

// Page to create the first account 

class CloudConfigPage extends StatelessWidget {

  CloudConfigPage({
    super.key,
    required this.token,
    required this.company
  });

  final String token;
  Company company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      // appBar: getAppBar("Cloud config authentification"),
      appBar: getAppBarUserSpace("Cloud config authentification", context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // different button for each request, right now only change the distant broker 
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.1,
              height: MediaQuery.sizeOf(context).height / 8,
              child: TextButton(
                style: ButtonStyle (
                  backgroundColor: MaterialStateProperty.all<Color>(grey)
                ),
                onPressed: () {
                  // send on the page of configuration of broker info 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrokerInfoConfigPage(
                        token: token,
                        company: company,
                      ),
                    ),
                  ).then((newCompany) {
                    // Here get the new broker info 
                    company = newCompany;
                  });
                },
                child: AutoSizeText(
                  "Config broker cloud",
                  style: TextStyle(
                    fontSize: 20,
                    color: white
                  ),
                  maxLines: 1,
                )
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.1,
              height: MediaQuery.sizeOf(context).height / 8,
              child: TextButton(
                style: ButtonStyle (
                  backgroundColor: MaterialStateProperty.all<Color>(grey)
                ),
                onPressed: () async {
                  // create a new connection in the home page with information of the cloud 
                  // entered by admin

                  await addConnection("cloud", company.brokerAddress, company.brokerPort);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: AutoSizeText(
                  "Get cloud broker connection",
                  style: TextStyle(
                    fontSize: 20,
                    color: white
                  ),
                  maxLines: 1,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}