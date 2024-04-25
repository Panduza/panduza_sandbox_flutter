import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/rest_request.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class AddBenchToConfigForm extends StatelessWidget {

  const AddBenchToConfigForm({
    super.key,
    required this.token
  });

  final String token;

  @override
  Widget build(BuildContext context) {

    final ctrlName = TextEditingController();

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
                // Send a request to api to created a new bench
                postBench(token, ctrlName.text).then((value) {
                  
                  // instead to keep a copy of the data we can make a 
                  // new request to get every bench to the API

                  getBench(token).then((response) {
                    Map<String, dynamic> responseObject = json.decode(response.body);
                    Navigator.pop(context, responseObject["bench"]);
                  });
                });
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