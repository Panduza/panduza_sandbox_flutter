import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/pages/add_device_page.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/ic_blc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_bpc.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_platform.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_powermeter.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/ic_not_managed.dart';

// import '../widgets/interface_control/icw_bpc.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';

class UserspaceDevicesPage extends StatefulWidget {
  const UserspaceDevicesPage({
    super.key, 
    required this.brokerConnectionInfo, 
    required this.listInterfaceConnection,
    required this.benchName
  });

  final BrokerConnectionInfo brokerConnectionInfo;
  final List<InterfaceConnection> listInterfaceConnection;
  final String benchName;

  @override
  State<UserspaceDevicesPage> createState() => _UserspaceDevicesPageState();
}

class _UserspaceDevicesPageState extends State<UserspaceDevicesPage> {
  List<InterfaceConnection> interfacesBench = [];

  // Map who associate a device to different interfaces
  final Map<String, List<InterfaceConnection>> deviceToInterfaces = {}; 

  @override 
  void initState() {
    super.initState();
    for (var interface in widget.listInterfaceConnection) {
      if (interface.getBenchName() == widget.benchName) {
        interfacesBench.add(interface);
      }
    }
  }

  bool interfaceAlreadyRegistered(InterfaceConnection ic) {
    for (var interface in interfacesBench) {
      if (interface.topic == ic.topic) {
        return true;
      }
    }
    // print(ic.topic);
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

  Widget interfaceControlItemBuiler(context, index) {
    // Get the type of the interface

    if (index >= interfacesBench.length) {
      return Container();
    }

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



  /*
  Widget interfaceControlItemBuiler(context, index, lic) {
    // Get the type of the interface

    print(deviceToInterfaces);

    if (index >= lic.length) {
      return Container();
    }

    final ic = lic[index];
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

  // Build item of the grid that control the interfaces
  /*
  Widget interfaceControlItemBuiler2(String key) {

    print(key);

    // Get the type of the interface

    if (!deviceToInterfaces.containsKey(key)) {
      return Container();
    }

    final List<InterfaceConnection>? listIc = deviceToInterfaces[key];

    if (listIc == null) {
      return Container();
    }

    print(listIc);
    print(listIc.length);

    /*
    for (var ic in listIc) {
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

    print(listIc.length);

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      itemCount: listIc.length,

      itemBuilder: (BuildContext context, int index) {
        return interfaceControlItemBuiler(context, index);
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
  */
  /*
  List<Widget> interfacesOfDevice(int index) {
    print(deviceToInterfaces.keys.elementAt(index));
    List<InterfaceConnection>? lic = deviceToInterfaces[deviceToInterfaces.keys.elementAt(index)];
    if (lic != null) {
      List<Widget> lw = [];
      for (var ic in lic) {
        final type = ic.info["type"];
        switch (type) {
          case "blc":
            lw.add(IcBlc(ic));
          case "bpc":
            lw.add(IcBpc(ic));
          case "platform":
            lw.add(IcPlatform(ic));
          case "powermeter":
            lw.add(IcPowermeter(ic));
          default:
            print("!!!! $type");
            lw.add(IcNotManaged(ic));
        }
      }

      return lw;
    }
    return [Container()];
  }
  */

  @override
  Widget build(BuildContext context) {
    // Get width of the widget
    final double width = MediaQuery.of(context).size.width;
    final int columns = (width / 300.0).round();

    return Scaffold(
      appBar: getAppBar("UserSpace"),
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
        itemCount: interfaces.length,

        itemBuilder: (BuildContext context, int index) {
          return interfaceControlItemBuiler(context, index);
        },
        separatorBuilder: (context, index) => const Divider(),
      )
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
        itemCount: interfaces.length,

        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: interfacesOfDevice(index),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      )
      */

      
      MasonryGridView.count(
        shrinkWrap: true,
        crossAxisCount: columns,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: interfaceControlItemBuiler
      ),
      
      
      /*
      MasonryGridView.count(
        shrinkWrap: true,
        itemCount: deviceToInterfaces.length,
        crossAxisCount: columns,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: interfaceControlItemBuiler
      )
      */
      /*
      GridView.count(
        shrinkWrap: true,
        crossAxisCount: columns,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: interfaceControlItemBuiler
      )
      */
      /*
      StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: const [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: Tile(index: 0),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: Tile(index: 1),
          ),
        ],
      )
      */

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