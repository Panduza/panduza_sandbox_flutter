import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/setup_pages/choice_cloud_self_managed_page.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/const.dart';


// Think about init SharedPreferences only to the start of the application

// late SharedPreferences prefs;

// ============================================================================
// Main enter point
void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(PanduzaSandboxApp(
    prefs: prefs,
  ));
}

// ============================================================================
// App Object
class PanduzaSandboxApp extends StatelessWidget {
  const PanduzaSandboxApp({
    super.key,
    required this.prefs
  });

  final SharedPreferences prefs;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panduza Sandbox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue
        ),
        scaffoldBackgroundColor: grey,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: white
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: white
          ),
          labelSmall: TextStyle(
            color: white,
            fontSize: 14
          ),
          labelMedium: TextStyle(
            color: black
          ),
          labelLarge: TextStyle(
            color: blue
          ),
          // bodySmall: getClassicTextStyle(),
          // displayLarge: getClassicTextStyle(),
          displayMedium: TextStyle(
            color: white,
            fontSize: 18,
            height: 2
          ),
          // displaySmall: getClassicTextStyle(),
          // headlineLarge: getClassicTextStyle(),
          // headlineMedium: getClassicTextStyle(),
          // headlineSmall: getClassicTextStyle(),
          // labelLarge: getClassicTextStyle(),
          // labelSmall: getClassicTextStyle(),
          // titleLarge: getClassicTextStyle(),
          // titleMedium: getClassicTextStyle(),
          // titleSmall: getClassicTextStyle()
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: grey)
      ),
      home: ChoiceCloudSelfManagedPage(
        prefs: prefs,
      ),
    );
  }
}
