import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mqtt_client/mqtt_client.dart';

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
import 'package:panduza_sandbox_flutter/pages/add_device_page.dart';

class UserspacePage extends StatefulWidget {
  const UserspacePage({super.key, required this.broker_connection_info});

  final BrokerConnectionInfo broker_connection_info;

  @override
  _UserspacePageState createState() => _UserspacePageState();
}

class _UserspacePageState extends State<UserspacePage> {
  List<InterfaceConnection> interfaces = [];

  // Map who associate a device to different interfaces
  final Map<String, List<InterfaceConnection>> deviceToInterfaces = {}; 

  bool interfaceAlreadyRegistered(InterfaceConnection ic) {
    for (var interface in interfaces) {
      if (interface.topic == ic.topic) {
        return true;
      }
    }
    // print(ic.topic);
    return false;
  }

  InterfaceConnection? findPlatform() {

    for (var interface in interfaces) {
      if (interface.info["type"] == "platform") {
        return interface;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    widget.broker_connection_info.client
          .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString('*');
    final payload = builder.payload;
    widget.broker_connection_info.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);

    Future.delayed(Duration(milliseconds: 100), () async {
      // Run your async function here
      // await myAsyncFunction();

      widget.broker_connection_info.client.updates!
          .listen((List<MqttReceivedMessage<MqttMessage>> c) {
        // final MqttMessage message = c[0].payload;

        // print('Received  from userspace from topic: ${c[0].topic}>');

        // final string = binascii.b2a_base64(bytearray(data)).decode('utf-8');
        // print(message.toString());

        // pza/*/atts/info

        if (c![0].topic.startsWith("pza") & c![0].topic.endsWith("atts/info")) {
          final recMess = c![0].payload as MqttPublishMessage;

          var topic = c![0]
              .topic
              .substring(0, c![0].topic.length - "/atts/info".length);

          final pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          var jsonObject = json.decode(pt);

          InterfaceConnection ic = InterfaceConnection(
            widget.broker_connection_info.client, topic, jsonObject["info"]
          );

          
          if (!interfaceAlreadyRegistered(ic)) {
            if (ic.getType() != "device") {
              setState(() {
                interfaces = [...interfaces, ic];
              });
            }
          }
          

          // if device not registered add a new list of interfaces connected to it
          if (!deviceToInterfaces.containsKey(ic.getDeviceName())) {
            deviceToInterfaces[ic.getDeviceName()] = [ic];
          } else {
            // The interfaceList cannot in normal case be null
            List<InterfaceConnection>? interfaceList = deviceToInterfaces[ic.getDeviceName()];
            if (interfaceList != null) {
              interfaceList.add(ic);
              deviceToInterfaces[ic.getDeviceName()] = interfaceList;
            }
          }
        }
        // final payload =
        // MqttPublishPayload.bytesToStringAsString(message.);

        // print('Received message:$payload from topic: ${c[0].topic}>');

        // sort and put in my map
        
        
      });
    });

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
  }

  // Build item of the grid that control the interfaces
  
  Widget interfaceControlItemBuiler(context, index) {
    // Get the type of the interface

    if (index >= interfaces.length) {
      return Container();
    }

    final ic = interfaces[index];
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
      
      // Button to add a device
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDevicePage(),
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
