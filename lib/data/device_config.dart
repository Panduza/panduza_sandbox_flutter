class DeviceConfig {
  String name = "test";

  String ref = "";

  Map<String, dynamic> settings = {};

  DeviceConfig({required this.ref, required this.settings, this.name = 'test'});

  Map<String, dynamic> toMap() {
    return {"ref": ref, "name": name, "settings": settings};
  }

  static DeviceConfig FromInstanceMap(Map<String, dynamic> instance) {
    String name = "test";
    if (instance.containsKey("name")) {
      name = instance["name"];
    }
    return DeviceConfig(
        ref: instance["ref"], settings: instance["settings"], name: name);
  }
  //  DeviceConfig
}
