import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDevicePage extends StatefulWidget {
  // get every connections existing on the disk

  const AddDevicePage(
    {
      super.key, 
      required this.listDevices,
      required this.prefs
    }
  );

  final Map<String, List<InterfaceConnection>> listDevices; 
  final SharedPreferences prefs;

  // BrokerSniffing brokenSniffer = BrokerSniffing();

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {

  String? currentDevice;

  final ctrlName = TextEditingController();

  
  @override
  void initState() {
    super.initState();

    currentDevice = widget.listDevices.keys.first;
  }

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
              ElevatedButton(
                onPressed: () {
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
              // Add every device defined in the dtree on the broker who make part of this bench test

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
            }, 
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(black)
            ),
            child: Text(
              'ADD EVERY POSSIBLE DEVICE',
              style: TextStyle(
                color: white
              ),
            ),
          )
        ],
      ),
    );


  }
}