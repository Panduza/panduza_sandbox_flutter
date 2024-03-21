import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';


// Page who will discover the differents platforms on 
// the network

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {

  List<(InternetAddress, int)> platformsIpsPorts = [];
  bool isLoading = false;
  Timer? timer;

  // Send broadcast to every ip connect on the same network connect to the port 
  // 

  void basicPlatformDiscovery() {
    platformDiscovery().then(
      (value) {
        platformsIpsPorts = value;
        platformsIpsPorts.sort((a, b) => a.$1.host.compareTo(b.$1.host));
        setState(() {});
      }
    );
  }

  @override
  void initState() {
    super.initState();
    basicPlatformDiscovery();
    
    // check if 
    timer = Timer.periodic(
      const Duration(seconds: 2), (Timer t) {
        basicPlatformDiscovery();
      }
    );
  }

  // Cancel the timer to not setState the page while the 

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Local Discovery"),
      body: localDiscoveryConnections(platformsIpsPorts, isLoading)
    );
  }
}