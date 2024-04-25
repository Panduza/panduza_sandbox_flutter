import 'package:mqtt_client/mqtt_server_client.dart';

class BrokerConnectionInfo {
  String host;
  int port;

  MqttServerClient client;
  
  BrokerConnectionInfo(this.host, this.port, this.client);
}