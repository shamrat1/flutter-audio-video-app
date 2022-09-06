import 'package:audio_test/offset_state.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';
import 'package:provider/provider.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String videoUrl =
      "examples.com/storage/fe7d3a0d44631509da1f416/2017/04/file_example_MP4_1280_10MG.mp4";
  double _height = 0;
  double _width = 0;
  bool _isExpanded = true;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  initVideo() async {
    videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpanded) {
      _height = MediaQuery.of(context).size.height * 0.99;
      _width = MediaQuery.of(context).size.width - 1;
      print(_height);
      print(_width);
    }
    return Consumer<OffsetState>(builder: (context, state, _) {
      return AnimatedPositioned(
        duration: Duration(microseconds: 100),
        left: state.offset.dx,
        top: state.offset.dy,
        child: Container(
          color: _isExpanded ? Colors.blue : Colors.amber,
          height: _height,
          width: _width,
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Display play/pause button and volume/speed sliders.
              chewieController != null &&
                      chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Container(
                      width: 300,
                      height: 200,
                      child: Chewie(controller: chewieController!),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),

              if (_isExpanded)
                Positioned(
                  left: 20,
                  top: 20,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = false;
                          _height = 200;
                          _width = 300;
                          // audioOffset =
                          //     Offset(0, MediaQuery.of(context).size.height * 0.90);
                          context.read<OffsetState>().update(Offset(
                              MediaQuery.of(context).size.width - _width,
                              MediaQuery.of(context).size.height -
                                  kBottomNavigationBarHeight -
                                  _height));
                        });
                      },
                      icon: Icon(
                        Icons.arrow_downward,
                      )),
                ),
              if (!_isExpanded)
                Positioned(
                  right: 20,
                  top: 20,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = true;
                          // audioOffset =
                          //     Offset(0, MediaQuery.of(context).size.height * 0.90);
                          context.read<OffsetState>().update(Offset(0, 0));
                        });
                      },
                      icon: Icon(
                        Icons.fullscreen,
                      )),
                ),
            ],
          ),
        ),
      );
    });
  }
}
