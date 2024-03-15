import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/templates.dart';

class IcNotManaged extends StatefulWidget {
  IcNotManaged(this._interfaceConnection);

  InterfaceConnection _interfaceConnection;

  @override
  _IcNotManagedState createState() => _IcNotManagedState();
}

class _IcNotManagedState extends State<IcNotManaged> {
  @override
  Widget build(BuildContext context) {
    return basicCard(
      cardHeadLine(widget._interfaceConnection),
    );
  }
}
