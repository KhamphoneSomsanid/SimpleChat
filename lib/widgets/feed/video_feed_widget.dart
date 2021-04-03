import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFeedWidget extends StatefulWidget {
  final dynamic feed;
  final Function() loaded;
  final Function(double) loading;
  final Function(int) willPlay;

  const VideoFeedWidget({
    Key key,
    @required this.feed,
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

    _playVideo(widget.feed.url);
  }

  @override
  void dispose() {
    if (_videoController != null) _videoController.dispose();
    super.dispose();
  }

  Future<void> _playVideo(String url) async {
    if (url.isNotEmpty && mounted) {
      _videoController = VideoPlayerController.network(url);
      _videoController.addListener(() {checkVideo();});

      await _videoController.initialize();
      await _videoController.play();
      widget.willPlay(_videoController.value.duration.inMilliseconds);
      setState(() {});
    }
  }

  void checkVideo() {
    if(_videoController.value.position == _videoController.value.duration) {
      widget.loaded();
    } else {
      double percent = _videoController.value.position.inMilliseconds / _videoController.value.duration.inMilliseconds;
      widget.loading(percent);
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
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      ),
    );
  }

}
