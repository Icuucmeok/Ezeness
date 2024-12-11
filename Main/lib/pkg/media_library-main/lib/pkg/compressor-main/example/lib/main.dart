import 'dart:io';

import 'package:compressor/models/color_model.dart';
import 'package:compressor/models/image_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:compressor/compressor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState(String videoPath) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/compressed_videos';
    await Directory(dirPath).create(recursive: true);
    final String compressedPath = '$dirPath/compressed_video.mp4';
    String? platformVersion;
    try {
      print("object ${File(videoPath).lengthSync()}");

      platformVersion =
          await Compressor.trimVideo(videoPath, compressedPath, 1, 4)

              // await Compressor.compressVideo(videoPath, compressedPath)
              ??
              'Unknown platform version';

      setState(() {
        _platformVersion = platformVersion!;
      });
      print("object ${File(_platformVersion).lengthSync()}");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }

  @override
  void didChangeDependencies() async {
    await Permission.storage.request();
    await Permission.values.request();
    await Permission.manageExternalStorage.request();
    super.didChangeDependencies();
  }

  bool busy = false;

  String? compressPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_platformVersion),
            TextButton(
                onPressed: () async {
                  //video_2024-05-09_20-11-56
                  //Ins_37736590
                  //high_quality
                  //"/data/user/0/com.example.flutter_application_1/cache/camerawesome/1716742158870860.mp4"
                  //"/storage/emulated/0/Download/video_2024-05-09_20-11-56.mp4"
                  await initPlatformState(
                      "/storage/emulated/0/Download/high_quality.mp4");
                },
                child: Text("Trim Video")),
            TextButton(
                onPressed: () async {
                  // VideoPlayerController _controller =
                  //     VideoPlayerController.file(File(
                  //         "/storage/emulated/0/Download/video_2024-05-09_20-11-56.mp4"));
                  // await _controller.initialize().then((_) {
                  //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  //   setState(() {});
                  // });
                  // if (_controller.value.isInitialized) {
                  //   print(_controller.value.size);
                  // }

                  final Directory extDir =
                      await getApplicationDocumentsDirectory();
                  final String dirPath = '${extDir.path}/compressed_videos';
                  await Directory(dirPath).create(recursive: true);
                  final String compressedPath =
                      '$dirPath/${DateTime.now().millisecondsSinceEpoch}.mp4';

                  print(
                      "object ${File("/storage/emulated/0/Download/high_quality.mp4").lengthSync()}");
                  compressPath = await Compressor.compressVideo(
                    "/storage/emulated/0/Download/Ins_-1852427997.mp4",
                    compressedPath,
                  );
                  setState(() {
                    _platformVersion = compressedPath;
                  });
                  print("object ${File(compressPath!).lengthSync()}");
                },
                child: Text("Compress Video")),
            TextButton(
                onPressed: applyFiltersAndOverlays,
                child: Text("Add Image Overlay Video")),
            TextButton(
                onPressed: () async {
                  final Directory extDir =
                      await getApplicationDocumentsDirectory();
                  final String dirPath = '${extDir.path}/exported_images';
                  await Directory(dirPath).create(recursive: true);
                  final String compressedPath = '$dirPath/export_image.PNG';

                  final image = await Compressor.exportCover(
                      "/storage/emulated/0/Download/high_quality.mp4",
                      compressedPath,
                      3);
                  setState(() {
                    _platformVersion = image!;
                  });
                },
                child: Text("export Cover")),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoApp(file: File(_platformVersion)),
                      ));
                },
                child: Text("show Video")),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageView(platformVersion: File(_platformVersion)),
                      ));
                },
                child: Text("show Image")),
            AnimatedBusyButton(
              title: 'SAVE',
              onPressed: () {
                setState(() {
                  busy = !busy;
                });
              },
              busy: busy,
            ),
            // if (_platformVersion != null || _platformVersion.isNotEmpty)
            // VideoApp(file: File(_platformVersion))
          ],
        ),
      ),
    );
  }

  void applyFiltersAndOverlays() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/compressed_videos';
    await Directory(dirPath).create(recursive: true);

    // Define the path for the compressed file (color filtered video)
    final String compressedPath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch}_filtered.mp4';

    // Path to the original video file
    final String originalVideoPath =
        "/storage/emulated/0/Download/Ins_-1852427997.mp4";
    final color = Color(0xFF0000);
    // Apply color filter
    String? filteredVideoPath = await Compressor.addFilterVideo(
        originalVideoPath,
        compressedPath,
        ColorModel(
            redValue: (color.red / 255),
            greenValue: (color.green / 255),
            blueValue: (color.blue / 255)));

    // Ensure the color filter was successfully applied
    if (filteredVideoPath != null) {
      final Uint8List imageBitmap =
          (await rootBundle.load("assets/images.png")).buffer.asUint8List();

      // Define a new path for the final video with overlays
      final String finalVideoPath =
          '$dirPath/${DateTime.now().millisecondsSinceEpoch}_with_overlays.mp4';

      // Apply overlays
      String? overlayVideoPath = await Compressor.addOverlays(
        filteredVideoPath,
        finalVideoPath,
        image: ImageModel(
          imageBitmap,
          30,
          30,
          300,
          300,
        ),
      );

      // Update the state with the final video path
      if (overlayVideoPath != null) {
        setState(() {
          _platformVersion = overlayVideoPath;
        });
      } else {
        print("Failed to apply overlays");
      }
    } else {
      print("Failed to apply color filter");
    }
  }
}

class AnimatedBusyButton extends StatefulWidget {
  final bool busy;
  final String title;
  final VoidCallback onPressed;
  final bool enabled;
  const AnimatedBusyButton(
      {required this.title,
      this.busy = false,
      required this.onPressed,
      this.enabled = true});

  @override
  _AnimatedBusyButtonState createState() => _AnimatedBusyButtonState();
}

class _AnimatedBusyButtonState extends State<AnimatedBusyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: InkWell(
        child: AnimatedContainer(
          height: widget.busy ? 60 : 75,
          width: widget.busy ? 60 : 200,
          curve: Curves.easeIn,
          duration: const Duration(seconds: 1),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: widget.busy ? 10 : 15,
              vertical: widget.busy ? 10 : 10),
          decoration: BoxDecoration(
            color: widget.enabled ? Colors.blue[800] : Colors.blue[300],
            borderRadius: BorderRadius.circular(5),
          ),
          child: !widget.busy
              ? Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              : CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.yellowAccent)),
        ),
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  final File? platformVersion;
  const ImageView({super.key, required this.platformVersion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.file(platformVersion!),
    ));
  }
}

class VideoApp extends StatefulWidget {
  final File file;
  const VideoApp({super.key, required this.file});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
