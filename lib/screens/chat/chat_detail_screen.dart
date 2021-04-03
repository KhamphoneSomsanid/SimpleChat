import 'package:flutter/material.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/feed/image_feed_widget.dart';
import 'package:simplechat/widgets/feed/video_feed_widget.dart';

class ChatDetailScreen extends StatefulWidget {
  final MediaModel data;

  const ChatDetailScreen({Key key, @required this.data}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: widget.data.type + ' Feed',
      ),
      body: _content(),
    );
  }

  Widget _content() {
    switch (widget.data.type) {
      case 'IMAGE':
        return ImageFeedWidget(feed: widget.data,);
      case 'VIDEO':
        return VideoFeedWidget(feed: widget.data,);
    }
    return Container();
  }
}
