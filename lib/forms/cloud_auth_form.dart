import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class CloudAuthForm extends StatelessWidget {

  const CloudAuthForm({super.key});

  @override
  Widget build(BuildContext context) {

    final ctrlUsername = TextEditingController();
    final ctrlPassword = TextEditingController();

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
                controller: ctrlUsername,
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: white
                    )
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: blue
                    )
                  ),
                ),
              ),
              // Password field to authentificate 
              TextField(
                controller: ctrlPassword,
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  // Color or the container underline when not field not 
                  // tap
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: white
                    )
                  ),
                  // Color or the container underline when field has been tap
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: blue
                    )
                  ),
                ),
                obscureText: true,
              ),
              Row(
                children: <Widget>[
                  TextButton(
                    child: Text(
                      "Create a user",
                      style: TextStyle(
                        color: blue
                      ),
                    ),
                    onPressed: () {
                      // send on web page to create a account or ask to the user to buy
                      // a new admin account for his organization
                    },
                  )
                ],
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
                // connect to the api admin, get broker info before change of page
                login(ctrlUsername.text, ctrlPassword.text).then((tokenResponse) {
                  if (tokenResponse.statusCode == 200) {
                    String token = json.decode(tokenResponse.body)['access'];
                    getBrokerInfo(token).then((brokerInfoResponse) {
                      if (brokerInfoResponse.statusCode == 200) {
                        // deserialize the company object into a object (maybe it could be 
                        // made alone with a function deserialize or something)
                        Map<String, dynamic> responseObject = json.decode(brokerInfoResponse.body);

                        String companyName = responseObject["company_name"];
                        String brokerAddress = responseObject["broker_address"];
                        String brokerPort = responseObject["broker_port"];
                        String certificat = responseObject["certificat"];

                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CloudConfigPage(
                              token: token,
                              company: Company(companyName, brokerAddress, brokerPort, certificat)
                            )
                          ),
                        );
                        */
                      } else {
                        // mangage error code 
                        print("error with get broker info request : ${brokerInfoResponse.statusCode}");
                      }
                    });
                  } else {
                    // manage error code
                    print("error with login request : ${tokenResponse.statusCode}");
                  }
                });
              }, 
              // Show error message if unsuccessful connection
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'CONNECT',
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