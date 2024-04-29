import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/add_connection_page.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/connections_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/setup_pages/cloud_config_auth_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';

// Page to give the choice between use the panduza cloud or 
// use a broker the user has himself init

class ChoiceCloudSelfManagedPage extends StatelessWidget {

  late final SharedPreferences _prefs;
  late final _prefsFuture = SharedPreferences.getInstance().then((v) => _prefs = v);

  ChoiceCloudSelfManagedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar at the top of the application
      appBar: getAppBar("Use Self-Managed broker or Cloud ?"),
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!(_prefs.containsKey(connectionKey))) {
              // If any connection already created send on the first add connection page 
              // when self-managed broker button tap 
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.1,
                      height: MediaQuery.sizeOf(context).height / 5,
                      child: TextButton(
                        style: ButtonStyle (
                          backgroundColor: MaterialStateProperty.all<Color>(black)
                        ),
                        onPressed: () {
                          // Go to cloud Authentification page
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const CloudAuthPage())
                          );
                        },
                        child: AutoSizeText(
                          'Panduza Cloud',
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
                          backgroundColor: MaterialStateProperty.all<Color>(black)
                        ),
                        onPressed: () {
                          // Go to cloud Local discovery page (with option to activate manual broker info)
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const AddConnectionPage())
                          );
                        },
                        child: AutoSizeText(
                          'Self-Managed Broker',
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
              );
            } else {
              // If a connection has already been created send on the connections page
              // (the user can see the already add connection) when self-managed broker button tap
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.1,
                      height: MediaQuery.sizeOf(context).height / 5,
                      child: TextButton(
                        style: ButtonStyle (
                          backgroundColor: MaterialStateProperty.all<Color>(black)
                        ),
                        onPressed: () {
                          // Go to cloud Authentification page
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const CloudAuthPage())
                          );
                        },
                        child: AutoSizeText(
                          'Panduza Cloud',
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
                          backgroundColor: MaterialStateProperty.all<Color>(black)
                        ),
                        onPressed: () {
                          // Go to cloud Local discovery page (with option to activate manual broker info)
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const ConnectionsPage())
                          );
                        },
                        child: AutoSizeText(
                          'Self-Managed Broker',
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
              );
            }
          } else {
            // return bar progression
            return const SizedBox.shrink();
          }
        }
      )
    );
  }
}