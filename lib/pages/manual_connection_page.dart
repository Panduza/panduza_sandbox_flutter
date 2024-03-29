import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/add_connection_form.dart';

import '../data/const.dart';
import 'home/mqtt_connection_form.dart';

// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud
class ManualConnectionPage extends StatefulWidget {
  const ManualConnectionPage({super.key});

  @override
  _ManualConnectionPageState createState() => _ManualConnectionPageState();
}

class _ManualConnectionPageState extends State<ManualConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: AppBar(
        // color of hamburger button
        iconTheme: IconThemeData(color: white),
        backgroundColor: black,
        title: Text(
          // widget.title,
          "Manual connection",
          style: TextStyle(
            color: blue,
          ),
        ),
        // Panduza logo
        // TO DO : Change to logo2 
        actions: <Widget>[
          IconButton(
            icon: Image.asset('../../assets/icons/logo_1024.png'),
            /*            
            icon: SvgPicture.asset(
              '../../assets/icons/logo2.svg'
            ),
            */
            iconSize: 50,
            onPressed: () {
              return;
            }, 
          )
        ],
      ),
      body: const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[AddConnectionForm()],
        ),
      ),
    );
  }
}