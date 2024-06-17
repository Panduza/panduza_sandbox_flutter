import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class AddDeviceToBenchForm extends StatelessWidget {

  const AddDeviceToBenchForm({
    super.key,
    required this.token,
    required this.benchId
  });

  final String token;
  final int benchId;

  @override
  Widget build(BuildContext context) {

    final ctrlName = TextEditingController();
    final ctrlType = TextEditingController();

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
                controller: ctrlName,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: ctrlType,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Type',
                ),
              ),
            ]
          ),
          
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
                // TO DO when cloud will be more advanced
              }, 
              // Show error message if unsuccessful connection
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'SAVE',
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