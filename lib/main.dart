import 'package:flutter/material.dart';
import 'pages/home_page.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
