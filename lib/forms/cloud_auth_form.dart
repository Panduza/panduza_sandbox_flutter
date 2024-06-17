import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/utils_widgets.dart';

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
              getSimpleTextField(context, ctrlUsername, 'Username'),
              // Password field to authentificate 
              getSimpleTextField(context, ctrlPassword, 'Password'),
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
                // TO DO when cloud will more advanced
              }, 
              // Show error message if unsuccessful connection
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(blue)
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