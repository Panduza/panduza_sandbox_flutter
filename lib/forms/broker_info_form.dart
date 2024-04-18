import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/company.dart';
import 'package:panduza_sandbox_flutter/pages/create_first_account_cloud_page.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class BrokerInfoConfigForm extends StatelessWidget {

  const BrokerInfoConfigForm({
    super.key,
    required this.token,
    required this.company
  });

  final String token;
  final Company company;

  @override
  Widget build(BuildContext context) {

    final ctrlCompanyName = TextEditingController(
      text: company.companyName
    );
    final ctrlBrokerAddress = TextEditingController(
      text: company.brokerAddress
    );
    final ctrlBrokerPort = TextEditingController(
      text: company.brokerPort
    );
    final ctrlCertificat = TextEditingController(
      text: company.certificat
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 30
          ),
          child: Column(
            children: <Widget>[
              TextField(
                controller: ctrlCompanyName,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'company name',
                ),
              ),
              TextField(
                controller: ctrlBrokerAddress,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'broker address'
                ),
              ),
              TextField(
                controller: ctrlBrokerPort,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'broker port'
                ),
              ),
              TextField(
                controller: ctrlCertificat,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'certificat'
                ),
              )
            ]
          )
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Connect to the broker with the info of username and password given
            ElevatedButton(
              onPressed: () {
                Company newCompany = Company(ctrlCompanyName.text, ctrlBrokerAddress.text,
                  ctrlBrokerPort.text, ctrlCertificat.text);
                // request to change company info with token information
                /*
                postBrokerInfo(token, newCompany).then((response) {
                  if (response.statusCode == 201) {
                    Navigator.pop(context, newCompany);
                  } else {
                    // manage error code 
                    print("post broker info failed ${response.statusCode}");
                  }
                });
                */

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateFirstAccountCloudPage(
                      token: token,
                      company: newCompany
                    )
                  ),
                );
              }, 
              // Show error message if unsuccessful connection
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'NEXT',
                style: TextStyle(
                  color: black
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}