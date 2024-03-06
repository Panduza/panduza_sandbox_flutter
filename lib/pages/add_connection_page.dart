import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/pages/discovery_page.dart';
import 'package:panduza_sandbox_flutter/pages/manual_connection_page.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../data/const.dart';
import 'home/mqtt_connection_form.dart';

// Page with the 3 choices of adding connection :
// with manual input, with discovery or with the cloud
class AddConnectionPage extends StatefulWidget {
  const AddConnectionPage({
    super.key,
  });

  @override
  _AddConnectionPageState createState() => _AddConnectionPageState();
}

class _AddConnectionPageState extends State<AddConnectionPage> {
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
                width: MediaQuery.sizeOf(context).width / 1.5,
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
                width: MediaQuery.sizeOf(context).width / 1.5,
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
                width: MediaQuery.sizeOf(context).width / 1.5,
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
      /*      
      body: ListView.separated(
        padding: const EdgeInsets.all(40),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              /*
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondRoute()),
                );
              },*/
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: grey,
                ),
                child: Center(
                  child: Column (
                    children: <Widget>[
                      Text(
                        '${brokers[index]}',
                        style: TextStyle(
                          color: blue
                        ),
                      ),
                      Text(
                        '${ips[index]}',
                        style: TextStyle(
                          color: white
                        ),
                      ),
                      Text(
                        '${ports[index]}',
                        style: TextStyle(
                          color: white
                        ),
                      )
                    ],
                  )
                ),
              )
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      */
    );
  }
}