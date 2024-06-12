import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:panduza_sandbox_flutter/data/interface_connection.dart';

import 'package:panduza_sandbox_flutter/userspace_widgets/templates.dart';

class IcVideo extends StatefulWidget {
  const IcVideo(this._interfaceConnection,
    {super.key}
  );

  final InterfaceConnection _interfaceConnection;

  @override
  State<IcVideo> createState() => _IcVideoState();
}

class _IcVideoState extends State<IcVideo> {

  int imageCount = 0;

  // Video Stream 
  StreamController<Uint8List> streamVideoController = StreamController<Uint8List>();
  
  // Subcription to broker message
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? mqttSubscription;

  // init the receving of frame on some topic (maybe add some topic) 

  void initFrameRecevingMqtt() {
    Future.delayed(Duration(milliseconds: 1), () {

      // Subscribe to receive message link to video
      String attsTopic = "${widget._interfaceConnection.topic}/atts/#";
      widget._interfaceConnection.client
          .subscribe(attsTopic, MqttQos.atLeastOnce);
      
      MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString('*');
      final payload = builder.payload;
      widget._interfaceConnection.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);

      print(widget._interfaceConnection.topic);

      if (streamVideoController.isClosed) {
        streamVideoController = StreamController<Uint8List>();
        print("reopen stream video");
      }

      // Listen every frame on the broker
      mqttSubscription = widget._interfaceConnection.client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {
        
        if (c![0].topic == "${widget._interfaceConnection.topic}/atts/frame") {
          
          final recMess = c![0].payload as MqttPublishMessage;

          // Reading frame and putting it on the video stream

          // From mjpeg

          var frameMjpeg = recMess.payload.message;
          var imageBytes = Uint8List.view(frameMjpeg.buffer, 0, frameMjpeg.length);
          streamVideoController.add(imageBytes);

          // From h264
        }
      });
    });
  }

  // Start to receive video at init
  @override
  void initState() {
    super.initState();
    initFrameRecevingMqtt();
  }

  // Stop listening broker message and close video stream
  @override
  void dispose() {
    mqttSubscription!.cancel();
    streamVideoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamVideoController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var imageData = Uint8List.fromList(snapshot.data);
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardHeadLine(widget._interfaceConnection),
                SizedBox(
                  height: 200,
                  width: 300,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.memory(
                      imageData,
                      gaplessPlayback: true,
                    ),
                  ),
                )
              ],
            )
          );
        } else {
          return const Card();
        }
      },
    ); 
  }
}