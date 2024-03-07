import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/add_connection_form.dart';
import 'package:panduza_sandbox_flutter/pages/edit_connection_form_page.dart';
import 'package:panduza_sandbox_flutter/pages/home_page.dart';

import '../data/const.dart';
import 'home/mqtt_connection_form.dart';

// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud
class EditPage extends StatefulWidget {
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
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  /*
  String name = "";
  String hostIp = "";
  String port = "";

  @override
  void initState() {
    name = widget.platformName;
    hostIp = widget.hostIp;
    port = widget.port;
    super.initState();
  }
  */

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
              platformName: widget.platformName,
              hostIp: widget.hostIp,
              port: widget.port,
            )],
        ),
      ),
    );
  }
}