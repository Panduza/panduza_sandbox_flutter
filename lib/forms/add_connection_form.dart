import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/connections_page.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';

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
      text: ip,
    );
    final ctrlPort = TextEditingController(
      text: port
    );
    bool isCloud = false;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 30
          ),
          child: Column(
            children: <Widget>[
              getSimpleTextField(context, ctrlName, 'Platform name'),
              getSimpleTextField(context, ctrlHostIp, 'Broker Hostname'),
              getSimpleTextField(context, ctrlPort, 'Broker Port'),
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
                // add connection info on the disk
                await addConnection(ctrlName.text, ctrlHostIp.text, ctrlPort.text, isCloud);
                Navigator.push(
                  context,  
                  MaterialPageRoute(builder: (context) => const ConnectionsPage())
                );
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