import 'package:flutter/material.dart';
import 'dart:convert';

// import '../widgets/interface_control/icw_bpc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/data/device_config.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// import 'userspace/ic_bpc.dart';
// import 'userspace/ic_not_managed.dart';
// import 'userspace/ic_platform.dart';

import '../data/interface_connection.dart';

// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../data/platform_config.dart';

// class BrokerConnectionInfo {
//   String host;
//   int port;

//   MqttServerClient client;

//   BrokerConnectionInfo(this.host, this.port, this.client);
// }

class DevicePage extends StatefulWidget {
  DevicePage(this._deviceStore, this._platformConfig, this._deviceConfig,
      {super.key});

  Map<dynamic, dynamic> _deviceStore;

  PlatformConfig _platformConfig;

  DeviceConfig _deviceConfig;

  @override
  _DevicePageState createState() => _DevicePageState(_deviceConfig);
}

class _DevicePageState extends State<DevicePage> {
  _DevicePageState(this._config);

  /// List of available refrences
  ///
  List<String>? _availableRefList;

  DeviceConfig _config;

  // String? _ref;

  late TextEditingController _nameController;

  ///
  ///
  Widget propertyWidget() {
    List<Widget> childrens = [];

    if (widget._deviceStore.containsKey(_config.ref)) {
      List<dynamic> settings_props =
          widget._deviceStore[_config.ref]["settings_props"];
      print(settings_props.toString());

      print(_config.settings);

      for (Map<String, dynamic> prop in settings_props) {
        if (prop["name"] is String) {
          final propName = prop['name'];
          switch (prop["type"]) {
            case "string":
              {
                childrens.add(TextField(
                  controller: TextEditingController(
                      text: _config.settings[propName] as String),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: propName,
                  ),
                  onChanged: (value) => {_config.settings[propName] = value},
                ));
                break;
              }
          }
        }
        //
      }
    }

    return Column(
      children: childrens,
    );
  }

  ///
  ///
  @override
  void initState() {
    super.initState();

    _availableRefList =
        convertListDynamicToString(widget._deviceStore.keys.toList());

    _nameController = TextEditingController(text: _config.name);
  }

  List<String> convertListDynamicToString(List<dynamic> listDynamic) {
    return listDynamic.map((dynamic element) => element as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_availableRefList == null) {
      return const SizedBox.shrink();
    } else {
      // Get width of the widget
      // final double width = MediaQuery.of(context).size.width;

      // final int columns = (width / 300.0).round();

      return Scaffold(
          appBar: AppBar(
            title: Text('Device ${_config.name}'),
          ),
          body: Column(children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              onChanged: (value) => {_config.name = value},
            ),
            DropdownButton<String>(
                items: _availableRefList!
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _config.ref,
                onChanged: (String? value) {
                  setState(() {
                    _config.ref = value!;
                  });
                }),
            propertyWidget(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Apply"),
            )
          ]));
    }
  }
}
