import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/utils/utils_functions.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/utils_widgets.dart';

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
                backgroundColor: WidgetStateProperty.all<Color>(black)
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
                // check if connection valid
                // remove connection to check if with edit a another connection exist with the same name or ip/port
                await removeConnection(platformName, hostIp, port);
                bool isValid = await checkIfConnectionValid(context, ctrlName.text, ctrlHostIp.text, ctrlPort.text);
                if (isValid) {
                  await addConnection(ctrlName.text, ctrlHostIp.text, ctrlPort.text, isCloud);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                } else {
                  await addConnection(platformName, hostIp, port, isCloud);
                }
              }, 
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(blue)
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