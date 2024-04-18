import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/data/company.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/pages/userspace_page.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class FirstUserCreationCloudForm extends StatelessWidget {

  const FirstUserCreationCloudForm({
    super.key,
    required this.token,
    required this.company,
  });

  final String token;
  final Company company;

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
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: ctrlPassword,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Password'
                ),
                obscureText: true,
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
            ElevatedButton(
              onPressed: () {
                // Change cloud broker info
                postBrokerInfo(token, company).then((response3) {

                  if (response3.statusCode == 201) {
                    // create first account in the cloud 
                    createFirstAccount(ctrlUsername.text, ctrlPassword.text, true).then((response) {

                      if (response.statusCode == 201) {
                        // get the cloud token
                        login(ctrlUsername.text, ctrlPassword.text, true).then((responseToken) {

                          if (responseToken.statusCode == 200) {
                            String cloudToken = json.decode(responseToken.body)['access'];
                            // Change local broker info
                            postBrokerInfo(cloudToken, company, true).then((response2) async {

                              if (response2.statusCode == 201) {
                                await addConnection("cloud", company.brokerAddress, company.brokerPort, true);
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              } else {
                                // manage error code 
                                print("post cloud broker info failed ${response2.statusCode}");
                              }
                            });
                          } else {
                            print("login failed ${responseToken.statusCode}");
                          }
                        });
                      } else {
                        print("first account creation failed ${response.statusCode}");
                      }
                    });
                  } else {
                    // manage error code 
                    print("post local broker info failed ${response3.statusCode}");
                  }
                });
              }, 
              // Show error message if unsuccessful connection
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'CREATE',
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