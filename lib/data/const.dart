import 'package:flutter/material.dart';

// First FF represent opacity of the colors 

Color white = const Color(0xFFFFFFFF);
Color black = const Color(0xFF000000);
Color blue = const Color(0xFF39B0FF);
Color grey = const Color(0xFF1E1E1E);

// storage keys

// Key to get every connection name (each name is used like a key to get the 
// information of the connection)
String connectionKey = "connectionName";

const int portLocalDiscovery = 53035;
const int portReceiveLocalDiscovery = 63008;

// String of info panduza cloud and self managed broker
const String panduzaCloudInfo = "You can use your\nown brokers here";
const String selfManagedBrokerInfo = "Panduza cloud\ninfo";
const String localDiscoveryInfo = "Look platforms on the\nlocal platform";
const String manualAddBrokerInfo = "Enter your own broker info";