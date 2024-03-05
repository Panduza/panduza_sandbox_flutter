import 'dart:io';
import 'package:udp/udp.dart';

/*
  This class will go looking for different brokers on the network sending 
  broadcast
*/

class BrokerSniffing {

  List<InternetAddress> ips = [];
  List<int> ports = []; 

  void sendBroadcast() async {
    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    var dataLength = await sender.send("I'm searching brokers".codeUnits, Endpoint.broadcast(port: const Port(65001)));
    var receiver = await UDP.bind(Endpoint.loopback(port: const Port(65002)));

    receiver.asStream(timeout: const Duration(seconds: 20)).listen((datagram) {
      if (datagram != null) {
        ips[ips.length] = datagram.address;
        ports[ports.length] = datagram.port;
      }
    });

    sender.close();
    receiver.close();
  }
}