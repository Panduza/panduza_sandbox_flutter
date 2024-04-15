import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/pages/userspace_page.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class FirstUserCreationForm extends StatelessWidget {

  const FirstUserCreationForm({
    super.key,
    required this.ip,
    required this.port,
  });

  final String ip;
  final String port;

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
                // create account with api if success try to connect to the broker with username and password given
                createFirstAccount(ctrlUsername.text, ctrlPassword.text).then((response) {
                  print(response.statusCode);
                  if (response.statusCode == 201) {
                    tryConnecting(ip, port, ctrlUsername.text, ctrlPassword.text).then((client) {
                      if (client != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserspacePage(
                              broker_connection_info: BrokerConnectionInfo(
                                ip, 
                                int.parse(port), 
                                client
                              ),
                            )
                          ),
                        ).then((value) {
                          client.disconnect();
                        });
                      }
                    });
                  }
                });
              }, 
              // Show error message if unsuccessful connection
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'CREATE AND CONNECT',
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