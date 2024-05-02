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
              getSimpleTextField(context, ctrlName, 'Connection Name'),
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
                // Check if the format is nearly valid

                // If any field is empty show a error 
                if (ctrlName.text.isEmpty || ctrlHostIp.text.isEmpty || ctrlPort.text.isEmpty) {
                  showMyDialogError(context, "A field is empty, you need to fill them all");
                  return;
                }

                // Check if the port is a number 
                if (int.tryParse(ctrlPort.text) == null) {
                  showMyDialogError(context, "Port need to be a number");
                  return;
                }

                // Check If any connection already with this same name
                if (await checkIfConnectionNameExist(ctrlName.text)) {
                  showMyDialogError(context, "This connection name already exist");
                  return;
                }

                // Check If any connection with the same ip/port already exist
                if (await checkIfPortIpExist(ctrlHostIp.text, ctrlPort.text)) {
                  showMyDialogError(context, "The ip/port combination is already in use for another connection");
                  return;
                }

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