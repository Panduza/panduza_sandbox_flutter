import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/edit_connection_form_page.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';

// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud

class EditPage extends StatelessWidget {
  const EditPage({
    super.key,
    required this.platformName,
    required this.hostIp,
    required this.port
  });

  final String platformName;
  final String hostIp;
  final String port;

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
          "Edit connection",
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
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[EditConnectionForm(
              platformName: platformName,
              hostIp: hostIp,
              port: port,
            )],
        ),
      ),
    );
  }
}