import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFeedWidget extends StatefulWidget {
  final dynamic feed;
  final File file;
  final Function() loaded;
  final Function(double) loading;
  final Function(int) willPlay;

  const VideoFeedWidget({
    Key key,
    this.feed,
    this.file,
    this.loaded,
    this.loading,
    this.willPlay,
  }) : super(key: key);

  @override
  _VideoFeedWidgetState createState() => _VideoFeedWidgetState();
}

class _VideoFeedWidgetState extends State<VideoFeedWidget> {
  VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    widget.feed == null? _playVideoFromFile(widget.file) : _playVideoFromUrl(widget.feed.url);
  }

  @override
  void dispose() {
    if (_videoController != null) _videoController.dispose();
    super.dispose();
  }

  Future<void> _playVideoFromFile(File file) async {
    if (file != null && mounted) {
      _videoController = VideoPlayerController.file(file);
      _videoController.addListener(() {checkVideo();});

      await _videoController.initialize();
      await _videoController.play();
      if (widget.willPlay != null ) widget.willPlay(_videoController.value.duration.inMilliseconds);
      setState(() {});
    }
  }

  Future<void> _playVideoFromUrl(String url) async {
    if (url.isNotEmpty && mounted) {
      _videoController = VideoPlayerController.network(url);
      _videoController.addListener(() {checkVideo();});

      await _videoController.initialize();
      await _videoController.play();
      if (widget.willPlay != null ) widget.willPlay(_videoController.value.duration.inMilliseconds);
      setState(() {});
    }
  }

  void checkVideo() {
    if(_videoController.value.position == _videoController.value.duration) {
      if (widget.loaded != null ) widget.loaded();
    } else {
      double percent = _videoController.value.position.inMilliseconds / _videoController.value.duration.inMilliseconds;
      if (widget.loading != null ) widget.loading(percent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return previewVideo();
  }

  Widget previewVideo() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Column(
        children: [
          if (widget.feed == null) VideoProgressIndicator(_videoController, allowScrubbing: true),
          Expanded(
            child: AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),
          ),
        ],
      ),
    );
  }

}
