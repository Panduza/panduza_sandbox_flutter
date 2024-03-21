import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/discovery_page.dart';
import 'package:panduza_sandbox_flutter/pages/manual_connection_page.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';

// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud

class AddConnectionPage extends StatelessWidget {
  const AddConnectionPage({
    super.key,
  });

  // Style button to navigate to the manual connection (add ip, port, name of a broker)
  // the discovery (page who are going to discover the local platform) and the cloud 
  // not yet added

  Widget buttonNavigation(BuildContext context, String buttonLabel, 
      MaterialPageRoute routePage) {
        
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: blue
        ),
        color: black,
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 1.1,
        height: MediaQuery.sizeOf(context).height / 5,
        child: TextButton(
          style: ButtonStyle (
            backgroundColor: MaterialStateProperty.all<Color>(black)
          ),
          onPressed: () {
            // go to manual connection
            Navigator.push(
              context,
              routePage
            );
          },
          child: AutoSizeText(
            buttonLabel,
            style: TextStyle(
              fontSize: 20,
              color: white
            ),
            maxLines: 1,
          )
        ),
      ),
    );     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Add connection"),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buttonNavigation(
                context, 
                "Manual connection", 
                MaterialPageRoute(
                  builder: (context) => const ManualConnectionPage(
                    ip: "",
                    port: ""
                  ), 
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 13
              ),
              buttonNavigation(
                context, 
                "Discovery", 
                MaterialPageRoute(
                  builder: (context) => const DiscoveryPage(),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 13
              ),
              buttonNavigation(
                context, 
                "Cloud", 
                MaterialPageRoute(
                  builder: (context) => const DiscoveryPage(),
                ),
              )
            ],
        ),
      ),
    );
  }
}