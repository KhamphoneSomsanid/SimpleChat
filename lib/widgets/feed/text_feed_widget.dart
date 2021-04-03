import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class TextFeedWidget extends StatelessWidget {
  final dynamic feed;
  final Function() loaded;

  const TextFeedWidget({
    Key key,
    @required this.feed,
    this.loaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loaded();
    return Container(
      child: Center(
        child: Text(
          feed.content,
          style: semiBold.copyWith(fontSize: fontLg, color: Colors.white),
        ),
      ),
    );
  }
}
