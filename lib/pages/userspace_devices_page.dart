import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:panduza_sandbox_flutter/pages/add_device_page.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_relay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/ic_blc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_bpc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_platform.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_not_managed.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/pages/edit_devices_page.dart';

// Page to display the different curently visible device with their 
// interfaces (relay, powermeter, amperemetre ...)

class UserspaceDevicesPage extends StatefulWidget {
  const UserspaceDevicesPage({
    super.key, 
    required this.brokerConnectionInfo, 
    required this.listInterfaceConnection,
    required this.benchName,
    required this.deviceToInterfaces
  });

  final BrokerConnectionInfo brokerConnectionInfo;
  final List<InterfaceConnection> listInterfaceConnection;
  final String benchName;
  final Map<String, List<InterfaceConnection>> deviceToInterfaces;

  @override
  State<UserspaceDevicesPage> createState() => _UserspaceDevicesPageState();
}

class _UserspaceDevicesPageState extends State<UserspaceDevicesPage> {

  List<InterfaceConnection> interfacesBench = [];
  List<String> deviceNames = [];
  Map<String, List<InterfaceConnection>> visibleInterfaces = {};
  Timer? timer;

  late final SharedPreferences _prefs;
  late final _prefsFuture = SharedPreferences.getInstance().then((v) => _prefs = v);

  /*
  void publishToAllPanduza() {
    widget.brokerConnectionInfo.client
          .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString('*');
    final payload = builder.payload;
    widget.brokerConnectionInfo.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);
  }
  */

  @override 
  void initState() {
    super.initState();

    // publishToAllPanduza();

    for (var interface in widget.listInterfaceConnection) {
      if (interface.getBenchName() == widget.benchName) {
        interfacesBench.add(interface);
      }
    }

    // Here it would be better to setState only when the map became different
    // but the only way to do that is compare complety the two
    timer = Timer.periodic(
      const Duration(seconds: 5), (Timer t) {
        setState(() {});
      }
    );

    deviceNames.addAll(widget.deviceToInterfaces.keys);
    deviceNames.sort(); 
  }

  @override 
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool interfaceAlreadyRegistered(InterfaceConnection ic) {
    for (var interface in interfacesBench) {
      if (interface.topic == ic.topic) {
        return true;
      }
    }
    return false;
  }

    /*
    Future.delayed(Duration(seconds: 2), () async {
      List<InterfaceConnection> newInterfaces = [];

      newInterfaces.add(findPlatform() as InterfaceConnection);

      for (var interface in interfaces) {
        if (interface.info["type"] != "platform") {
          newInterfaces.add(interface);
        }
      }

      interfaces = newInterfaces;
    });
    */

  // Build item of the grid that control the interfaces
  /*
  Widget interfaceControlItemBuiler(context, index) {

    // Get the type of the interface

    final ic = interfacesBench[index];
    final type = ic.info["type"];

    switch (type) {
      case "blc":
        return IcBlc(ic);
      case "bpc":
        return IcBpc(ic);
      case "platform":
        return IcPlatform(ic);
      case "powermeter":
        return IcPowermeter(ic);
      default:
        print("!!!! $type");
        return IcNotManaged(ic);
    }
  }
  */

  /*
  List<Widget> testOneDevice() {

    List<Widget> listWidget = [];

    final interfaceList = widget.deviceToInterfaces["test"];
    print("interface of test" + interfaceList.toString());

    if (interfaceList == null) return listWidget;

    for (var interface in interfaceList) {

      final type = interface.getType();

      switch (type) {
        case "blc":
          listWidget.add(IcBlc(interface));
        case "bpc":
          listWidget.add(IcBpc(interface));
        case "platform":
          listWidget.add(IcPlatform(interface));
        case "powermeter":
          listWidget.add(IcPowermeter(interface));
        default:
          print("!!!! $type");
          listWidget.add(IcNotManaged(interface));
      }
    }

    print(listWidget);

    return listWidget;
  }
  */

  Widget getListWidgetsForOneDevice(int index, List<InterfaceConnection> listCo) {

    
    final type = listCo[index].getType(); 
    switch (type) {
      case "blc":
        return IcBlc(listCo[index]);
      case "bpc":
        return IcBpc(listCo[index]);
      case "platform":
        return IcPlatform(listCo[index]);
      case "powermeter":
        return IcPowermeter(listCo[index]);
      default:
        // print("!!!! $type");
        return IcNotManaged(listCo[index]);
    }
  }
  
  
  List<Widget> getWidgetsForOneDevice(String deviceName) {
    List<Widget> widgetsForDevice = [];

    if (widget.deviceToInterfaces[deviceName] == null) return widgetsForDevice;

    List<InterfaceConnection> listInterface = 
      widget.deviceToInterfaces[deviceName] as List<InterfaceConnection>;

    for (InterfaceConnection interface in listInterface) {
      final type = interface.info["type"]; 
      switch (type) {
        case "blc":
          widgetsForDevice.add(IcBlc(interface));
        case "bpc":
         widgetsForDevice.add(IcBpc(interface));
        case "platform":
          widgetsForDevice.add(IcPlatform(interface));
        case "powermeter":
          widgetsForDevice.add(IcPowermeter(interface));
        default:
          widgetsForDevice.add(IcNotManaged(interface));
      }
    }

    return widgetsForDevice;
  }

  // Build item of the grid that control the interfaces
  Widget interfaceControlItemBuiler(context, index) {
    // Get the type of the interface

    if (index >= widget.listInterfaceConnection.length) {
      return Container();
    }

    final ic = widget.listInterfaceConnection[index];
    final type = ic.info["type"];

    switch (type) {
      case "blc":
        return IcBlc(ic);
      case "bpc":
        return IcBpc(ic);
      case "platform":
        return IcPlatform(ic);
      case "powermeter":
        return IcPowermeter(ic);
      default:
        return IcNotManaged(ic);
    }
  }

  // Build item of the grid that control the interfaces
  /*
  Widget interfaceControlItemBuiler2(context, index, index2) {
    // Get the type of the interface

    if (index >= widget.deviceToInterfaces.keys.length) {
      return const SizedBox.shrink();
    }

    // here I could use a loop to see which interface must be visible but yes (it would be better to 
    // look for a better solution)

    List<InterfaceConnection>? listInterface = widget.deviceToInterfaces[deviceNames[index]];

    if (listInterface == null) {
      return const SizedBox.shrink();
    }

    if (index2 >= listInterface.length) {
      return const SizedBox.shrink();
    }

    final ic = listInterface[index2];
    final type = ic.info["type"];

    switch (type) {
      case "blc":
        return IcBlc(ic);
      case "bpc":
        return IcBpc(ic);
      case "platform":
        return IcPlatform(ic);
      case "powermeter":
        return IcPowermeter(ic);
      default:
        // print("!!!! $type");
        return IcNotManaged(ic);
    }
  }
  */
  
  // Build item of the grid that control the interfaces
  Widget interfaceControlItemBuiler2(context, index, index2) {
    // Get the type of the interface

    if (index >= visibleInterfaces.keys.length) {
      return const SizedBox.shrink();
    }

    // here I could use a loop to see which interface must be visible but yes (it would be better to 
    // look for a better solution)

    List<InterfaceConnection>? listInterface = visibleInterfaces[deviceNames[index]];

    if (listInterface == null) {
      return const SizedBox.shrink();
    }

    if (index2 >= listInterface.length) {
      return const SizedBox.shrink();
    }

    final ic = listInterface[index2];
    final type = ic.info["type"];

    switch (type) {
      case "blc":
        return IcBlc(ic);
      case "bpc":
        return IcBpc(ic);
      case "platform":
        return IcPlatform(ic);
      case "powermeter":
        return IcPowermeter(ic);
      case "relay":
        return IcRelay(ic);
      default:
        // print("!!!! $type");
        return IcNotManaged(ic);
    }
  }

  // Display of 1 device with his visible interfaces 

  Widget deviceWithVisibleInterfaces(List<String> visibleDevicesNames, int index,
      SharedPreferences prefs) {

    return Column(
      children: <Widget>[
        Container(
          color: black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    visibleDevicesNames[index],
                    style: TextStyle(
                      color: white
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        EditDevicePage(
                          deviceName: visibleDevicesNames[index],
                          deviceInterfacesVisible: visibleInterfaces[visibleDevicesNames[index]] as List<InterfaceConnection>,
                          deviceInterfaces: widget.deviceToInterfaces[visibleDevicesNames[index]] as List<InterfaceConnection>, 
                          prefs: prefs
                        )
                    ),
                  ).then((value) {
                    // load the new interface to show, only need to change one device 

                    List<InterfaceConnection>? interfaces = widget.deviceToInterfaces[visibleDevicesNames[index]];
                    List<InterfaceConnection> interfaceVisible = [];
                    List<String>? nameVisibleInterfaces = _prefs.getStringList(visibleDevicesNames[index]);

                    if (nameVisibleInterfaces != null && interfaces != null) {

                      for (var interface in interfaces) {
                        if (nameVisibleInterfaces.contains(interface.getInterfaceName())) {
                          interfaceVisible.add(interface);
                        }
                      }

                      if (interfaceVisible != []) {
                        visibleInterfaces[visibleDevicesNames[index]] = interfaceVisible;
                      }
                    
                    }
                    
                    setState(() {});
                  });
                }, 
                icon: Icon(
                  Icons.edit,
                  color: white,
                  size: 20,
                ),
              ), 
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actionsAlignment: MainAxisAlignment.center,
                        title: const Center(
                          child: Text('Are you sure ?'),
                        ),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: black
                              ),
                            ),
                            onPressed: () {
                              // remove the widget of the targeted device

                              prefs.remove(visibleDevicesNames[index]);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: black
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                }, 
                icon: Icon(
                  Icons.delete,
                  color: white,
                  size: 20,
                ),
              )
            ],
          ),
        ),

        // The container of every interfaces inside the box of the device 
        // we can change the number of element on a single row with crossAxisCount 
        // this parameter is going to change a lot based on the screen size

        MasonryGridView.builder(
          // itemCount: (widget.deviceToInterfaces[visibleDevicesNames[index]] as List<InterfaceConnection>).length,
          itemCount: prefs.getStringList(visibleDevicesNames[index])?.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
          ),
          shrinkWrap: true,
          // crossAxisCount: columns,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          itemBuilder: (context2, index2) {
            return interfaceControlItemBuiler2(context2, index, index2);
          }
        )
      ],
    );
  }
  
  // Display every devices who has been chosen by the user

  Widget listDevicesWithInterfaces(SharedPreferences prefs) {

    // get a list of the device name who has been choose by the user (on the disk)

    List<String> visibleDevicesNames = [];
    
    for (var deviceName in deviceNames) {
      if (prefs.containsKey(deviceName)) {
        visibleDevicesNames.add(deviceName);
      }
    } 

    /*
    return ListView.separated (
      itemCount: visibleDevicesNames.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Row (
            children: <Widget>[
              Container(
                width: MediaQuery.sizeOf(context).width / 2,
                decoration: const BoxDecoration(
                  // color: Colors.blueGrey,
                  // color: Color(0xFF606060)
                  // color: Color(0xFF5A5E6B)
                  // color: Color(0xFF303030)
                  color: Color(0xFF696969)
                  // color: Color(0xFF463F32)
                  // color: Color(0xFF2F4F4F)
                ),
                child: deviceWithVisibleInterfaces(visibleDevicesNames, index, prefs)
              ),
            ],
          ) 
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    ); 
    */

    // A device box, currently there only two devices by line can be changed 
    // with the crossAxisCount (can have strong esthetics difference), 
    // I think it's better to set it pretty low (something like 2-3) for mobile application but 
    // for desktop application can be easily put to 4

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 4,
      itemCount: visibleDevicesNames.length,
       itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: const BoxDecoration(
                // color: Colors.blueGrey,
                // color: Color(0xFF606060)
                // color: Color(0xFF5A5E6B)
                // color: Color(0xFF303030)
                color: Color(0xFF696969)
                // color: Color(0xFF463F32)
                // color: Color(0xFF2F4F4F)
              ),
              child: deviceWithVisibleInterfaces(visibleDevicesNames, index, prefs)
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;
    final int columns = (width / 300.0).round();

    return Scaffold(
      appBar: getAppBar("Bench : ${widget.benchName}"),
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // get the current visible interface for each device 

            // n² but not a lot of device for a bench so I think it's not a real problem 
            // but try to find a better alternative 

            for (String deviceName in deviceNames) {

              List<InterfaceConnection>? interfaces = widget.deviceToInterfaces[deviceName];
              List<InterfaceConnection> interfaceVisible = [];
              List<String>? nameVisibleInterfaces = _prefs.getStringList(deviceName);

              if (nameVisibleInterfaces != null && interfaces != null) {

                for (var interface in interfaces) {
                  if (nameVisibleInterfaces.contains(interface.getInterfaceName())) {
                    interfaceVisible.add(interface);
                  }
                }

                if (interfaceVisible != []) {
                  visibleInterfaces[deviceName] = interfaceVisible;
                }
              }
            }
            return listDevicesWithInterfaces(_prefs);
          } 
          // `_prefs` is not ready yet, show loading bar till then.
          return const CircularProgressIndicator(); 
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDevicePage(
                listDevices: widget.deviceToInterfaces,
                prefs: _prefs,
              ),
            ),
          ).then((value) => setState(() {}));
        },
        backgroundColor: black,
        shape: const CircleBorder(
          eccentricity: 1.0,
        ),
        child: Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }
}