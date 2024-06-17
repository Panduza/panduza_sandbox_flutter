import 'package:flutter/material.dart';

import 'package:panduza_sandbox_flutter/utils/const.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/device_config.dart';
import 'package:panduza_sandbox_flutter/widgets/utils_widgets/appBar.dart';
import 'package:panduza_sandbox_flutter/utils/utils_objects/platform_config.dart';


class DevicePage extends StatefulWidget {
  const DevicePage(this._deviceStore, this._deviceConfig,
      {super.key});

  final Map<dynamic, dynamic> _deviceStore;

  // PlatformConfig _platformConfig;

  final DeviceConfig _deviceConfig;

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
      List<dynamic> settingsProps =
          widget._deviceStore[_config.ref]["settingsProps"];
      print(settingsProps.toString());

      print(_config.settings);

      for (Map<String, dynamic> prop in settingsProps) {
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
        appBar: getAppBar('Device ${_config.name}'),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: white
                )
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
              }
            ),
            propertyWidget(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Apply"),
            )
          ]
        )
      );
    }
  }
}
