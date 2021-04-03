import 'package:flutter/material.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/feed/image_feed_widget.dart';
import 'package:simplechat/widgets/feed/video_feed_widget.dart';

class PostFeedScreen extends StatefulWidget {
  final dynamic data;
  final String type;

  const PostFeedScreen({Key key, this.data, this.type}) : super(key: key);

  @override
  _PostFeedScreenState createState() => _PostFeedScreenState();
}

class _PostFeedScreenState extends State<PostFeedScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: widget.type + ' Feed',
      ),
      body: Stack(
        children: [
          if (widget.type == 'IMAGE') ImageFeedWidget(file: widget.data,),
          if (widget.type == 'VIDEO') VideoFeedWidget(file: widget.data,),
        ],
      )
    );
  }
}
