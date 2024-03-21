import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';

class AddDevicePage extends StatefulWidget {

  const AddDevicePage(
    {
      super.key, 
      required this.listDevices,
      required this.prefs
    }
  );

  final Map<String, List<InterfaceConnection>> listDevices; 
  final SharedPreferences prefs;

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {

  String? currentDevice;

  final ctrlName = TextEditingController();

  
  @override
  void initState() {
    super.initState();

    // The dropbar will take the first value of the list of the devices 

    currentDevice = widget.listDevices.keys.first;
  }

  // The list of item of the drop down list representing the different 
  // device of the current test bench

  List<DropdownMenuItem<String>>? listDropDown() {
    List<DropdownMenuItem<String>>? listMenuItem = [];

    for (String deviceName in widget.listDevices.keys) {
      /*
      if (!widget.prefs.containsKey(deviceName)) {
        
      }
      */
      listMenuItem.add(
        DropdownMenuItem(
          value: deviceName,
          child: Text(
            deviceName
          ),
        )
      );
    }

    return listMenuItem;
  }

  // When cancel button pressed return on the precedent page 
  
  void cancelButtonOnPressedFunction() {
    Navigator.pop(context);
  }

  // When add button pressed, add a device on the list of the visible device 
  // and on the disk, so when the user will come back later on the devices pages 
  // the devices he has chosen will stay on the page 

  void addButtonOnPressedFunction() {
    
    // we add the name the targeted device to list of visible device (only 
    // the visibles devices are present on the device page)

    // At the start every interface of the devices are visibles 

    List<String> visibleDeviceInterfaces = [];
    List<InterfaceConnection>? listInterface = widget.listDevices[currentDevice];

    if (listInterface != null) {
      for (var interface in listInterface) {
        visibleDeviceInterfaces.add(interface.getInterfaceName());
      }

      widget.prefs.setStringList(currentDevice as String, visibleDeviceInterfaces);
    }

    Navigator.pop(context);
  }

  // Do the same thing than the add button but for every devices present on this bench 
  // (present on the broker)

  void addEveryPossibleDeviceButtonOnPressedFunction() {
    for (var deviceName in widget.listDevices.keys) {
      List<String> visibleDeviceInterfaces = [];
      List<InterfaceConnection>? listInterface = widget.listDevices[deviceName];

      if (listInterface != null) {
        for (var interface in listInterface) {
          visibleDeviceInterfaces.add(interface.getInterfaceName());
        }
      }
      print(visibleDeviceInterfaces);
      widget.prefs.setStringList(deviceName, visibleDeviceInterfaces);
    }
    
    Navigator.pop(context);
  }

  // get a dropDownList widget with every device you can choose on this bench 
  // like item

  Widget dropDownListStyle() {
    return Padding(
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
          child: DropdownButton<String> (
            underline: const SizedBox.shrink(),
            items: listDropDown(),
            value: currentDevice,
            onChanged: (String? value) {
              setState(() {
                currentDevice = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  // Page to add a visible device from a drop down list
  // at first every interface of the device are load 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add device"),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height/3,
          ),
          dropDownListStyle(),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              basicButtonStyle(
                cancelButtonOnPressedFunction, 
                'CANCEL',
                black,
                white
              ),
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
            addEveryPossibleDeviceButtonOnPressedFunction, 
            'ADD EVERY POSSIBLE DEVICE', 
            black, 
            white
          )
        ],
      ),
    );
  }
}