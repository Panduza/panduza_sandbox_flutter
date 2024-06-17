import 'package:flutter/material.dart';
import 'templates.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/interface_connection.dart';

class IcNotManaged extends StatefulWidget {
  const IcNotManaged(this._interfaceConnection, {super.key});

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcNotManaged> createState() => _IcNotManagedState();
}

class _IcNotManagedState extends State<IcNotManaged> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: cardHeadLine(widget._interfaceConnection),
    );
  }
}
