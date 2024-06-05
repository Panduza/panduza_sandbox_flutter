import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:yuv_to_png/yuv_to_png.dart';
import 'package:yuv_converter/yuv_converter.dart';

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

  // late WinVideoPlayerController controller;

  int imageCount = 0;

  // Video Stream 

  StreamController<Uint8List> streamVideoController = StreamController<Uint8List>();

  // init the receving of frame on some topic (maybe add some topic) 

  void initFrameRecevingMqtt() {
    Future.delayed(Duration(milliseconds: 1), () {

      String attsTopic = "${widget._interfaceConnection.topic}/atts/#";
      // print(attsTopic);
      Subscription? sub = widget._interfaceConnection.client
          .subscribe(attsTopic, MqttQos.atLeastOnce);
      
      // widget._interfaceConnection.client
      //     .subscribe("pza/default/video/channel/atts/frame", MqttQos.atLeastOnce);

      MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString('*');
      final payload = builder.payload;
      widget._interfaceConnection.client
        .publishMessage('pza', MqttQos.atLeastOnce, payload!);

      print(widget._interfaceConnection.topic);

      // Listen every frame
      widget._interfaceConnection.client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {
        
        if (c![0].topic == "${widget._interfaceConnection.topic}/atts/frame") {
          // print("i");
          
          final recMess = c![0].payload as MqttPublishMessage;

          // Using mjpeg

          var frameMjpeg = recMess.payload.message;
          var imageBytes = Uint8List.view(frameMjpeg.buffer, 0, frameMjpeg.length);
          streamVideoController.add(imageBytes);

          // Using YUV convert to ?
          
          // var frameYUV = recMess.payload.message;
          // var imageBytes = Uint8List.view(frameYUV.buffer, 0, frameYUV.length);
          // Uint8List rgbga1 = YuvConverter.yuv422yuyvToRgba8888(imageBytes, 512, 512);
          // streamVideoController.add(rgbga1);

          // Using h264
        }
      });
    });
  }



  @override
  void initState() {
    super.initState();
    initFrameRecevingMqtt();
  }

  @override
  void dispose() {
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
          // print("arggg");
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