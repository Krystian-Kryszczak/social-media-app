import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/widget/progress/app_progress_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/exhibit/watch/watch.dart';

class WatchPlayerFrame extends StatefulWidget {
  final Watch watch;

  const WatchPlayerFrame({
    super.key,
    required this.watch,
  });

  @override
  State<WatchPlayerFrame> createState() => _WatchPlayerFrameState();
}

class _WatchPlayerFrameState extends State<WatchPlayerFrame> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    String? watchUrl = widget.watch.getUrl();
    if (watchUrl == null) {
      Navigator.pop(context);
      return;
    }
    _controller = VideoPlayerController.network(watchUrl!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Chewie(
        controller: _chewieController
      ),
    ) : AspectRatio(
      aspectRatio: _controller.value.aspectRatio*1.75,
      child: Container(
        color: Colors.black,
        child: const Center(
          child: AppProgressIndicator()
        ),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }
}
