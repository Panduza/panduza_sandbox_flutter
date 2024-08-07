import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/pages/after_setup_pages/userspace_page.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class AuthentificationForm extends StatelessWidget {

  const AuthentificationForm({
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
                style: Theme.of(context).textTheme.displayMedium
              ),
              TextField(
                controller: ctrlPassword,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Password'
                ),
                obscureText: true,
                style: Theme.of(context).textTheme.displayMedium
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
                tryConnecting(ip, port, ctrlUsername.text, ctrlPassword.text).then((client) {
                  if (client != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserspacePage(
                          brokerConnectionInfo: BrokerConnectionInfo(
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
              }, 
              // Show error message if unsuccessful connection
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'CONNECT',
                style: Theme.of(context).textTheme.labelMedium
              ),
            )
          ],
        )
      ],
    );
  }
}