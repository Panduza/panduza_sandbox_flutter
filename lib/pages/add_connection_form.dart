import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/const.dart';
import '../data/utils.dart';


// Form to add a new manual connection 
// The user can add on his disk a new setup of connection mqtt

class AddConnectionForm extends StatefulWidget {

  const AddConnectionForm({
    super.key,
    /*
    required this.hostIp,
    required this.port
    */
  });
  
  /*
  String hostIp;
  String port;
  */

  @override
  _AddConnectionForm createState() => _AddConnectionForm();
}

class _AddConnectionForm extends State<AddConnectionForm> {

  final _ctrlName = TextEditingController();
  final _ctrlHostIp = TextEditingController();
  final _ctrlPort = TextEditingController();

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
              onPressed: () {
                addConnection(_ctrlName.text, _ctrlHostIp.text, _ctrlPort.text);
                getConnections();

                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
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

  