import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/pages/discovery_page.dart';
import 'package:panduza_sandbox_flutter/pages/manual_connection_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/ic_blc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_bpc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_platform.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_not_managed.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/forms/add_bench_form.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';


// First display a list of the interface than a user can add with a button add, cancel, add all 
// (like in the add device page)
// Second display the current device with this interfaces and put button on them to make them visible 
// or not 


class EditDevicePage extends StatefulWidget {

  EditDevicePage (
    {
      super.key, 
      required this.deviceName,
      required this.deviceInterfaces,
      required this.deviceInterfacesVisible,
      required this.prefs
    }
  );

  final String deviceName;
  final List<InterfaceConnection> deviceInterfaces;
  List<InterfaceConnection> deviceInterfacesVisible; 
  final SharedPreferences prefs;

  // BrokerSniffing brokenSniffer = BrokerSniffing();

  @override
  _EditDevicePageState createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<EditDevicePage> {

  InterfaceConnection? currentInterface;

  final ctrlName = TextEditingController();

  void callbackSetState() {
    List<String>? listNameInterfaces = widget.prefs.getStringList(widget.deviceName);
    List<InterfaceConnection> newListVisibleInterfaces = [];

    listNameInterfaces ??= [];

    for (var interface in widget.deviceInterfaces) {
      if (listNameInterfaces.contains(interface.getInterfaceName())) {
        newListVisibleInterfaces.add(interface);
      }
    }

    widget.deviceInterfacesVisible = newListVisibleInterfaces;

    setState(() {});
  }

  
  @override
  void initState() {
    super.initState();

    currentInterface = widget.deviceInterfaces.first;
  }
  
  // List of the interface of the device that the user can add 
  List<DropdownMenuItem<InterfaceConnection>>? listDropDown() {
    List<DropdownMenuItem<InterfaceConnection>>? listMenuItem = [];

    for (InterfaceConnection deviceName in widget.deviceInterfaces) {
      /*
      if (!widget.prefs.containsKey(deviceName)) {
        
      }
      */
      listMenuItem.add(
        DropdownMenuItem(
          value: deviceName,
          child: Text(
            "${deviceName.getType()} ${deviceName.getInterfaceName()}"
          ),
        )
      );
    }

    return listMenuItem;
  }

  Widget interfaceControlItemBuiler2(context, index) {
    // Get the type of the interface

    if (widget.deviceInterfacesVisible == null) {
      return const SizedBox.shrink();
    }

    if (index >= widget.deviceInterfacesVisible.length) {
      return const SizedBox.shrink();
    }

    final ic = widget.deviceInterfacesVisible[index];
    final type = ic.info["type"];

    switch (type) {
      case "blc":
        return IcBlc(ic, 
          isEdit: true, 
          prefs: widget.prefs, 
          deviceName: widget.deviceName,
          editSetState: callbackSetState,
        );
      case "bpc":
        return IcBpc(ic, 
          isEdit: true, 
          prefs: widget.prefs, 
          deviceName: widget.deviceName,
          editSetState: callbackSetState,
        );
      case "platform":
        return IcPlatform(ic, 
          isEdit: true, 
          prefs: widget.prefs, 
          deviceName: widget.deviceName,
          editSetState: callbackSetState,
        );
      case "powermeter":
        return IcPowermeter(ic, 
          isEdit: true, 
          prefs: widget.prefs, 
          deviceName: widget.deviceName,
          editSetState: callbackSetState,
        );
      default:
        // print("!!!! $type");
        return IcNotManaged(ic, 
          isEdit: true, 
          prefs: widget.prefs, 
          deviceName: widget.deviceName,
          editSetState: callbackSetState,
        );
    }
  }

  Widget deviceWithVisibleInterfaces(String deviceName, SharedPreferences prefs) {

    return Column(
      children: <Widget>[
        Container(
          color: grey,
          child: Center(
            child: Text(
              deviceName,
              style: TextStyle(
                color: white
              ),
            ),
          ),
        ),
        MasonryGridView.builder(
          itemCount: widget.deviceInterfacesVisible.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4
          ),
          shrinkWrap: true,
          // crossAxisCount: columns,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          itemBuilder: (context, index) {
            return interfaceControlItemBuiler2(context, index);
          }
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Edit device"),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // The current display of the device 
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: white
              ),
              color: Color(0xFF696969)
            ),
            child: deviceWithVisibleInterfaces(widget.deviceName, widget.prefs)
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 30
            ),
            child: Container (
              width: 400,
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Center (
                child: DropdownButton<InterfaceConnection> (
                  underline: const SizedBox.shrink(),
                  items: listDropDown(),
                  value: currentInterface,
                  onChanged: (InterfaceConnection? value) {
                    setState(() {
                      currentInterface = value!;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                // We add on the disk a new interface attach to this device
                onPressed: () {

                  List<String>? listNameInterfaces = widget.prefs.getStringList(widget.deviceName);
                  String? currentInterfaceName = currentInterface?.getInterfaceName();

                  listNameInterfaces ??= [];

                  if (!listNameInterfaces.contains(currentInterfaceName)) {

                    listNameInterfaces.add(currentInterfaceName as String);
                    widget.prefs.setStringList(widget.deviceName, listNameInterfaces);

                    widget.deviceInterfacesVisible.add(currentInterface as InterfaceConnection);
                    setState(() {});
                  }
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
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              // Add every interface of the device
              List<String>? listNameInterfaces = widget.prefs.getStringList(widget.deviceName);

              listNameInterfaces ??= [];

              for (var interface in widget.deviceInterfaces) {
                if (!listNameInterfaces.contains(interface.getInterfaceName())) {
                  listNameInterfaces.add(interface.getInterfaceName());
                  widget.deviceInterfacesVisible.add(interface);
                }
              }

              widget.prefs.setStringList(widget.deviceName, listNameInterfaces);
              setState(() {});
            }, 
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(black)
            ),
            child: Text(
              'ADD EVERY POSSIBLE INTERFACE',
              style: TextStyle(
                color: white
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}