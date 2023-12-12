import 'package:mqtt_client/mqtt_server_client.dart';

/// Minimal data package to access an interface from the application
///
class InterfaceConnection {
  /// Mqtt client connection
  MqttServerClient client;

  /// Interface Topic
  String topic;

  /// Interface Info
  Map info;

  /// Constructor
  InterfaceConnection(this.client, this.topic, this.info);

  String getType() {
    return info["type"];
  }

  String getDeviceName() {
    final elements = topic.split("/");
    final index = elements.length - 2;
    return elements[index];
  }

  String getInterfaceName() {
    final elements = topic.split("/");
    final index = elements.length - 1;
    return elements[index];
  }
}

// pza/server/alien/test
