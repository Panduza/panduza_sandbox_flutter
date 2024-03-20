import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/templates.dart';

class IcNotManaged extends StatefulWidget {
  IcNotManaged(this._interfaceConnection, {
    super.key,
    this.isEdit = false,
    this.prefs, 
    this.deviceName,
    this.editSetState
  });

  final InterfaceConnection _interfaceConnection;
  final bool isEdit;
  final SharedPreferences? prefs;
  final String? deviceName;
  final Function? editSetState;


  @override
  _IcNotManagedState createState() => _IcNotManagedState();
}

class _IcNotManagedState extends State<IcNotManaged> {
  @override
  Widget build(BuildContext context) {
    return basicCard(
      cardHeadLine(
        widget._interfaceConnection, 
        widget.isEdit,
        deviceName: widget.deviceName,
        prefs: widget.prefs,
        editSetState: widget.editSetState
      ),
    );
  }
}
