// Android version

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:panduza_sandbox_flutter/data/const.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();

//     // Create and store the VideoPlayerController. The VideoPlayerController
//     // offers several different constructors to play videos from assets, files,
//     // or the internet.
//     _controller = VideoPlayerController.asset("assets/WIN_20240527_15_37_55_Pro.mp4");

//     // Initialize the controller and store the Future for later use.
//     _initializeVideoPlayerFuture = _controller.initialize();

//     // Use the controller to loop the video.
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     _controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Butterfly Video'),
//       ),
//       // Use a FutureBuilder to display a loading spinner while waiting for the
//       // VideoPlayerController to finish initializing.
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the VideoPlayerController has finished initialization, use
//             // the data it provides to limit the aspect ratio of the video.
//             return Container(
//               color: white,
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 // Use the VideoPlayer widget to display the video.
//                 child: VideoPlayer(_controller),
//               )
//             );
             
//           } else {
//             // If the VideoPlayerController is still initializing, show a
//             // loading spinner.
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Wrap the play or pause in a call to `setState`. This ensures the
//           // correct icon is shown.
//           setState(() {
//             // If the video is playing, pause it.
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               // If the video is paused, play it.
//               _controller.play();
//             }
//           });
//         },
//         // Display the correct icon depending on the state of the player.
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
// }

// Windows version


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:video_player_win/video_player_win.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:image/image.dart' as I;
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/userspace_widgets/templates.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';



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

          // Decode and add them in the stream of frame

          var frameMjpeg = recMess.payload.message;
          var imageBytes = Uint8List.view(frameMjpeg.buffer, 0, frameMjpeg.length);
          streamVideoController.add(imageBytes);
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
  
    // return Scaffold(
    //   appBar: getAppBar('video_player_win example app'),

    //   // Using mjpeg
    //   body: 
    //   body: Card(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         cardHeadLine(widget._interfaceConnection),
            
            
    //       ],
    //     )
    //   ),
    // );
  }
}