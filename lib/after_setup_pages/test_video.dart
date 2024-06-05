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
import 'package:mqtt_client/mqtt_client.dart';
import 'package:image/image.dart' as I;

import 'package:panduza_sandbox_flutter/data/interface_connection.dart';
import 'package:panduza_sandbox_flutter/data/broker_connection_info.dart';
import 'package:panduza_sandbox_flutter/utils_widgets/appBar.dart';



class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.broker_connection_info});

  final BrokerConnectionInfo broker_connection_info;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  // late WinVideoPlayerController controller;

  int imageCount = 0;

  // Video Stream 

  StreamController<Uint8List> streamVideoController = StreamController<Uint8List>();

  // init the receving of frame on some topic (maybe add some topic) 

  void initFrameRecevingMqtt() {
    Future.delayed(Duration(milliseconds: 1), () {
      
      widget.broker_connection_info.client
          .subscribe('test/frame', MqttQos.atLeastOnce);

      MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString('*');
      final payload = builder.payload;
      widget.broker_connection_info.client
        .publishMessage('test', MqttQos.atLeastOnce, payload!);

      widget.broker_connection_info.client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {

      // print(c![0].topic);
      if (c![0].topic.startsWith("test/frame")) {
        final recMess = c![0].payload as MqttPublishMessage;

        // print(recMess.payload.message);
        var frameMjpeg = recMess.payload.message;

        // print("pif");
        var imageBytes = Uint8List.view(frameMjpeg.buffer, 0, frameMjpeg.length);
        streamVideoController.add(imageBytes);

        /*
        I.Image? img2 = I.decodeImage(imageBytes);
        
        if (img2 != null) {
          
          File("C:\\Users\\UF205DAL\\Pictures\\test\\$imageCount.png").writeAsBytes(I.encodePng(img2));
          imageCount++;
          print("Image storing success");

          // FlutterFFmpeg ffmpegClient = FlutterFFmpeg();

          // // Decode a input from type mjpeg
          // // ffmpeg -i input.mov -c:v mjpeg -q:v 3 -an output.mov
          // // "ffmpeg -i $imageBytes -c:v mjpeg -q:v 3 -an C:\\Users\\UF205DAL\\Pictures\\test\\output.mov"
  
          // ffmpegClient.execute("-framerate 7 -start_number 49 -i  C:\\Users\\UF205DAL\\Pictures\\test\\%d.png -c:v libx264 -r 30 -pix_fmt yuv420p C:\\Users\\UF205DAL\\Pictures\\test\video.mp4").then(
          //   (code) {
          //     if (code == 0) {
          //       print("success");
          //     } else {
          //       print("failure with code : $code");
          //     }
          //   }
          // );
        }
        */
      }
    });
  });

  }



  @override
  void initState() {
    super.initState();

    // FlutterFFmpeg ffmpegClient = FlutterFFmpeg();

    // Decode a input from type mjpeg
    // ffmpeg -i input.mov -c:v mjpeg -q:v 3 -an output.mov
    // "ffmpeg -i $imageBytes -c:v mjpeg -q:v 3 -an C:\\Users\\UF205DAL\\Pictures\\test\\output.mov"

    // ffmpegClient.execute("-framerate 7 -start_number 0 -i  C:\\Users\\UF205DAL\\Pictures\\test\\%d.png -c:v libx264 -r 30 -pix_fmt yuv420p C:\\Users\\UF205DAL\\Pictures\\test\\video.mp4").then(
    //   (code) {
    //     if (code == 0) {
    //       print("success");
    //     } else {
    //       print("failure with code : $code");
    //     }
    //   }
    // );
   
    /*
    controller = WinVideoPlayerController.file(File("C:\\Users\\UF205DAL\\panduza_sandbox_flutter\\assets\\WIN_20240527_15_37_55_Pro.mp4"));
    controller.initialize().then((value) {
      if (controller.value.isInitialized) {
        controller.play();
        setState(() {});
      } else {
        log("video file load failed");
      }
    });
    */
    // widget.broker_connection_info.client
    //       .subscribe('*', MqttQos.atLeastOnce);

    // MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    // builder.addString('*');
    // final payload = builder.payload;

    // widget.broker_connection_info.client
    //     .publishMessage('test', MqttQos.atLeastOnce, payload!);

    // widget.broker_connection_info.client
    //       .subscribe('pza/+/+/+/atts/info', MqttQos.atLeastOnce);

    // MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    // builder.addString('*');
    // final payload = builder.payload;
    // widget.broker_connection_info.client
    //     .publishMessage('pza', MqttQos.atLeastOnce, payload!);

    // Future.delayed(Duration(milliseconds: 1), () async {
    //   // Run your async function here
    //   // await myAsyncFunction();

    //   widget.broker_connection_info.client.updates!
    //       .listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //     // final MqttMessage message = c[0].payload;

    //     // print('Received  from userspace from topic: ${c[0].topic}>');

    //     // final string = binascii.b2a_base64(bytearray(data)).decode('utf-8');
    //     // print(message.toString());

    //     // pza/*/atts/info
    //     // print(c[0].topic);
    //     print("paf");
    //     if (c![0].topic.startsWith("test/frame")) {
    //       final recMess = c![0].payload as MqttPublishMessage;

    //       // var topic = c![0]
    //       //     .topic
    //       //     .substring(0, c![0].topic.length - "/frame".length);

    //       final pt =
    //           MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    //       var jsonObject = json.decode(pt);

    //       print(c![0].topic);
    //       print(pt);
    //     }
    //   }
    // );

    // Using win video player Controller
    
    // controller = WinVideoPlayerController.file(File("C:\\Users\\UF205DAL\\panduza_sandbox_flutter\\assets\\WIN_20240527_15_37_55_Pro.mp4"));
    // controller.initialize().then((value) {
    //   if (controller.value.isInitialized) {
    //     controller.play();
    //     setState(() {});
    //   } else {
    //     log("video file load failed");
    //   }
    // });
    

    // Using stream and jpeg
    
   
  }

  @override
  void dispose() {
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('video_player_win example app'),

      // Using win video controller

      // body: Stack(children: [
      //   WinVideoPlayer(controller),
      //   Positioned(
      //     bottom: 0,
      //     child: Column(children: [
      //       ValueListenableBuilder(
      //         valueListenable: controller,
      //         builder: ((context, value, child) {
      //           int minute = controller.value.position.inMinutes;
      //           int second = controller.value.position.inSeconds % 60;
      //           return Text("$minute:$second", style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white, backgroundColor: Colors.black54));
      //         }),
      //       ),
      //       ElevatedButton(onPressed: () => controller.play(), child: const Text("Play")),
      //       ElevatedButton(onPressed: () => controller.pause(), child: const Text("Pause")),
      //       ElevatedButton(onPressed: () => controller.seekTo(Duration(milliseconds: controller.value.position.inMilliseconds+ 10*1000)), child: const Text("Forward")),
      //     ])),
      // ]),

      // Using mjpeg
      body: StreamBuilder(
        stream: streamVideoController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // print("paf");
            var imageData = Uint8List.fromList(snapshot.data);
            return Image.memory(
              imageData,
              gaplessPlayback: true,
            );
          } else {
            return Container();
          }
        },
      )  
    );
  }
}