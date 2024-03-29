import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/home_page.dart';

import '../data/const.dart';
import '../data/utils.dart';


// Form to edit a existing connection

class EditConnectionForm extends StatefulWidget {

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
  _EditConnectionForm createState() => _EditConnectionForm();
}

class _EditConnectionForm extends State<EditConnectionForm> {

  final _ctrlName = TextEditingController();
  final _ctrlHostIp = TextEditingController();
  final _ctrlPort = TextEditingController();

  @override
  void initState() {
    _ctrlName.text = widget.platformName;
    _ctrlHostIp.text = widget.hostIp;
    _ctrlPort.text = widget.port;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _ctrlName,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Platform name',
                ),
                
              ),
              TextField(
                controller: _ctrlHostIp,
                // textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Broker Hostname'
                ),
              ),
              TextField(
                controller: _ctrlPort,
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
                await editConnection(widget.platformName, _ctrlName.text, _ctrlHostIp.text, _ctrlPort.text);
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
      ],
    );
  }
  
}

  