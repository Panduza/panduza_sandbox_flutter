import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:panduza_sandbox_flutter/pages/add_device_page.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/ic_blc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_bpc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_platform.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_not_managed.dart';

// import '../widgets/interface_control/icw_bpc.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';

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
  Timer? timer;

  // I should go check the max size of list<InterfaceConnection> in the map
  final maxItem = 10;

  
  void publishToAllPanduza() {
    widget.brokerConnectionInfo.client
          .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString('*');
    final payload = builder.payload;
    widget.brokerConnectionInfo.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);
  }
  

  @override 
  void initState() {
    super.initState();

    publishToAllPanduza();

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
  
  Widget interfaceControlItemBuiler2(context, index, index2) {
    // Get the type of the interface

    if (index >= widget.deviceToInterfaces.keys.length) {
      return const SizedBox.shrink();
    }

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
  
  

  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;
    final int columns = (width / 300.0).round();

    return Scaffold(
      appBar: getAppBar("Bench : ${widget.benchName}"),
      body: 

      /*
      ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        itemCount: deviceToInterfaces.length,

        itemBuilder: (BuildContext context, int index) {
          return interfaceControlItemBuiler2(deviceToInterfaces.keys.elementAt(index));
        },
        separatorBuilder: (context, index) => Container(),
      )
      */
      

      /*
      ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: widget.deviceToInterfaces.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,

        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: getWidgetsForOneDevice(widget.deviceToInterfaces.keys.elementAt(index)),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      */
      
      /*
      Column(
        // Start with the platform then display every device
        children: <Widget>[
          Center(
            child: Container(
              height: MediaQuery.sizeOf(context).height / 3,
              width: MediaQuery.sizeOf(context).width / 3,
              child: IcPlatform(findPlatform() as InterfaceConnection),
            )
          ),
        ]
      )
      */
      /*
      ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: interfacesBench.length,

        itemBuilder: (BuildContext context, int index) {
          return interfaceControlItemBuiler(context, index);
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      */

      // one device 
      /*
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: blue
          ),
          color: black,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: (widget.deviceToInterfaces["test"] as List<InterfaceConnection>).length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // number of items per row
            crossAxisCount: 5,
            // vertical spacing between the items
            mainAxisSpacing: 0,
            // horizontal spacing between the items
            crossAxisSpacing: 0,
          ),
          itemBuilder: (context, index) {
            return getListWidgetsForOneDevice(index, widget.deviceToInterfaces["test"] as List<InterfaceConnection>);
          },
        ),
      ),
      */

      /*
      MasonryGridView.count(
        shrinkWrap: true,
        crossAxisCount: columns,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: interfaceControlItemBuiler
      ),
      */
      
      /*
      MasonryGridView.builder(
        itemCount: widget.listInterfaceConnection.length,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns
        ),
        shrinkWrap: true,
        // crossAxisCount: columns,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: interfaceControlItemBuiler
      ),
      */
      
      
      ListView.separated (
        itemCount: widget.deviceToInterfaces.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: blue
              ),
              color: black,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  deviceNames[index],
                  style: TextStyle(
                    color: white
                  ),
                ),
                MasonryGridView.builder(
                  itemCount: maxItem,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns
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
            )
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDevicePage(),
            ),
          );
          setState(() {});
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