import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';

// Form to edit a existing connection

class EditConnectionForm extends StatelessWidget {
  const EditConnectionForm({
    super.key,
    required this.platformName,
    required this.hostIp,
    required this.port
  });

  final String platformName;
  final String hostIp;
  final String port;

  @override
  Widget build(BuildContext context) {

    final ctrlName = TextEditingController();
    final ctrlHostIp = TextEditingController();
    final ctrlPort = TextEditingController();
    bool isCloud = false;

    ctrlName.text = platformName;
    ctrlHostIp.text = hostIp;
    ctrlPort.text = port;
    
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
              // need to manage the isCloud button
              /*
              CheckboxListTile(
                value: isCloud,
                onChanged: (value) {
                  isCloud = false;
                },
              ),
              */
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
                await editConnection(platformName, ctrlName.text, ctrlHostIp.text, ctrlPort.text, isCloud);
                if (!context.mounted) return;
                Navigator.pop(context);
              }, 
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(blue)
              ),
              child: Text(
                'EDIT',
                style: TextStyle(
                  color: black
                ),
              ),
            )
          ],
        )
      ]
    );
  }
}