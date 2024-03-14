import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';

// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class AddConnectionForm extends StatelessWidget {

  const AddConnectionForm({
    super.key,
    required this.ip,
    required this.port,
  });

  final String ip;
  final String port;

  @override
  Widget build(BuildContext context) {

    final ctrlName = TextEditingController();
    final ctrlHostIp = TextEditingController(
      text: ip
    );
    final ctrlPort = TextEditingController(
      text: port
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
                controller: ctrlName,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Platform name',
                ),
              ),
              TextField(
                controller: ctrlHostIp,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Broker Hostname'
                ),
              ),
              TextField(
                controller: ctrlPort,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Broker Port',
                ),
              ),
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
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(black)
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: white
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            // add the connection to the home page
            ElevatedButton(
              onPressed: () async {
                await addConnection(ctrlName.text, ctrlHostIp.text, ctrlPort.text);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }, 
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'ADD',
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