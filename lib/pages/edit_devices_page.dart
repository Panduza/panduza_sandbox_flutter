import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/ic_blc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_bpc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_platform.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_not_managed.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_relay.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';


// Page to add/remove visible interface of the targeted device 

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

  @override
  State<EditDevicePage> createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<EditDevicePage> {

  InterfaceConnection? currentInterface;
  final ctrlName = TextEditingController();

  // function to set the state of the page called inside of the template 
  // of every interface when their are removed (bin icon on edit device page)

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
  
  // List of the interface of the device that the user can add to make them 
  // become visible 

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

  // function to return the correct interface widget corresponding to the broker
  // information on the interfaces link to the targeted device 

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
      case "relay":
        return IcRelay(ic,
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

  // function displaying a device box with his current visible interfaces 

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

  // function to add a visible interface of the current device targeted by the edit 
  // icon on the device page 

  void addButtonOnPressedFunction() {
    List<String>? listNameInterfaces = widget.prefs.getStringList(widget.deviceName);
    String? currentInterfaceName = currentInterface?.getInterfaceName();

    listNameInterfaces ??= [];

    if (!listNameInterfaces.contains(currentInterfaceName)) {

      listNameInterfaces.add(currentInterfaceName as String);
      widget.prefs.setStringList(widget.deviceName, listNameInterfaces);

      widget.deviceInterfacesVisible.add(currentInterface as InterfaceConnection);
      setState(() {});
    }
  }   

  // Add every interface in the visible interface list of the targeted device

  void addEveryDeviceOnPressedFunction() {
  
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
  }
  
  // Page to add/remove visible interface of the targeted device 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Edit device"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              basicButtonStyle(
                addButtonOnPressedFunction,
                'ADD',
                blue,
                black
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          basicButtonStyle(
            addButtonOnPressedFunction,
            'ADD EVERY POSSIBLE INTERFACE',
            black,
            white
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}