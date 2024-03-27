import 'package:flutter/material.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panduza_sandbox_flutter/data/const.dart';
import 'package:panduza_sandbox_flutter/pages/add_connection_page.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/drawer.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/app_bar.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/utils_widgets.dart';
import 'package:panduza_sandbox_flutter/data/utils.dart';
import 'package:panduza_sandbox_flutter/data/const.dart';

// The test of perf of the broker (number of ping send and receive)
// test on 5 seconds

class PerfTestPage extends StatefulWidget {

  const PerfTestPage({super.key, required this.brokerConnection});

  final BrokerConnectionInfo brokerConnection;

  @override
  State<PerfTestPage> createState() => _PerfTestPageState();
}

class _PerfTestPageState extends State<PerfTestPage> {

  int? perf;

  @override
  Widget build(BuildContext context) {
    if (perf == null) {
      return Scaffold(
        appBar: getAppBar("Perf test"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text(
                  "Perf test",
                  style: TextStyle(
                    color: black
                  ),
                ),
                onPressed: () {
                  perfTest(widget.brokerConnection)!.then((int pingReceivedBySecond) {
                    setState(() {
                      perf = pingReceivedBySecond;
                    });
                  });
                },
              ),
            ),
          ],
        )
      ); 
    } else {
      return Scaffold(
        appBar: getAppBar("Perf test"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text(
                  "Perf test",
                  style: TextStyle(
                    color: black
                  ),
                ),
                onPressed: () {
                  perfTest(widget.brokerConnection)!.then((int pingReceivedBySecond) {
                    setState(() {
                      perf = pingReceivedBySecond;
                    });
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                '${perf.toString()} ping received by second',
                style: TextStyle(
                  color: white
                ),
              ),
            ),
          ],
        )
      ); 
    }
  }
}
