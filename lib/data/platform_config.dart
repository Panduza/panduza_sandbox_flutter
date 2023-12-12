import 'device_config.dart';
import 'dart:convert';

class PlatformConfig {
  List<DeviceConfig> devices = [];

  PlatformConfig({this.devices = const []});

  List<dynamic> mapDevices() {
    List<dynamic> list = [];

    for (DeviceConfig dev in devices) {
      list.add(dev.toMap());
    }

    return list;
  }

  Map<String, dynamic> toMap() {
    return {"devices": mapDevices()};
  }

  // ignore: non_constant_identifier_names
  static PlatformConfig FromMap(Map<String, dynamic> map) {
    List<DeviceConfig> devices = [];

    if (map.containsKey("devices")) {
      for (Map<String, dynamic> entry in map["devices"]) {
        // print(entry);
        devices.add(DeviceConfig.FromInstanceMap(entry));
      }
    }
    return PlatformConfig(devices: devices);
  }
}
