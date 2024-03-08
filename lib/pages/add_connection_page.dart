import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/discovery_page.dart';
import 'package:panduza_sandbox_flutter/pages/manual_connection_page.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';

// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud

class AddConnectionPage extends StatelessWidget {
  const AddConnectionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: black,
        title: Text(
          // widget.title,
          "Add connection",
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
            children: <Widget>[
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.1,
                height: MediaQuery.sizeOf(context).height / 5,
                child: TextButton(
                  style: ButtonStyle (
                    backgroundColor: MaterialStateProperty.all<Color>(grey)
                  ),
                  onPressed: () {
                    // go to manual connection
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualConnectionPage(),
                      ),
                    );
                  },
                  child: AutoSizeText(
                    "Manual connection",
                    style: TextStyle(
                      fontSize: 20,
                      color: white
                    ),
                    maxLines: 1,
                  )
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 13
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.1,
                height: MediaQuery.sizeOf(context).height / 5,
                child: TextButton(
                  style: ButtonStyle (
                    backgroundColor: MaterialStateProperty.all<Color>(grey)
                  ),
                  onPressed: () {
                    // go to manual connection
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiscoveryPage(),
                      ),
                    );
                  },
                  child: AutoSizeText(
                    "Discovery",
                    style: TextStyle(
                      fontSize: 20,
                      color: white
                    ),
                    maxLines: 1,
                  )
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 13
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.1,
                height: MediaQuery.sizeOf(context).height / 5,
                child: TextButton(
                  style: ButtonStyle (
                    backgroundColor: MaterialStateProperty.all<Color>(grey)
                  ),
                  onPressed: () {
                    // go to manual connection
                  },
                  child: AutoSizeText(
                    "Cloud",
                    style: TextStyle(
                      fontSize: 20,
                      color: white
                    ),
                    maxLines: 1,
                  )
                ),
              )
            ],
        ),
      ),
    );
  }
}