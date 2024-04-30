import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/add_connection_page.dart';
import 'package:panduza_sandbox_flutter/after_setup_pages/connections_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';
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
                    // get the button to go to the login page of cloud 
                    // with info icon to get the information giving details
                    // on what the cloud can currently offer 
                    getTransitionButton(context, const CloudAuthPage(), panduzaCloudInfo, 'Panduza Cloud'),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 13
                    ),
                    // get the button to go to the page to add a self managed
                    // broker or if a connection already exist go to the connections page 
                    // with a info icon to precise what is a self managed broker 
                    getTransitionButton(context, const AddConnectionPage(), selfManagedBrokerInfo, 'Self-Managed Broker')
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
                    // get the button to go to the login page of cloud 
                    // with info icon to get the information giving details
                    // on what the cloud can currently offer 
                    getTransitionButton(context, const CloudAuthPage(), panduzaCloudInfo, 'Panduza Cloud'),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 13
                    ),
                    // get the button to go to the page to add a self managed
                    // broker or if a connection already exist go to the connections page 
                    // with a info icon to precise what is a self managed broker 
                    getTransitionButton(context, const ConnectionsPage(), selfManagedBrokerInfo, 'Self-Managed Broker')
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