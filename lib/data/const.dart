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