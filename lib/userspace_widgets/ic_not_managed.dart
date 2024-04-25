import 'package:flutter/material.dart';
import 'templates.dart';
import '../../data/interface_connection.dart';

class IcNotManaged extends StatefulWidget {
  IcNotManaged(this._interfaceConnection);

  InterfaceConnection _interfaceConnection;

  @override
  _IcNotManagedState createState() => _IcNotManagedState();
}

class _IcNotManagedState extends State<IcNotManaged> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: cardHeadLine(widget._interfaceConnection),
    );
  }
}
