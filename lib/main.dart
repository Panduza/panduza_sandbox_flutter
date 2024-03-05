import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';

import 'pages/home_page.dart';
import 'data/const.dart';

// ============================================================================
// Main enter point
void main() {
  runApp(const PanduzaSandboxApp());
}

// ============================================================================
// App Object
class PanduzaSandboxApp extends StatelessWidget {
  const PanduzaSandboxApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panduza Sandbox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: black),
        useMaterial3: true,
      ),
      // routes: {
      //   // '/second': (BuildContext context) => SecondPage(),
      //   // '/userspace': (BuildContext context) => UserspacePage(),
      // },
      home: const HomePage(title: 'Panduza Sandbox'),
    );
  }
}
