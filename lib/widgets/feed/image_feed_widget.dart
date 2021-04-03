import 'package:flutter/material.dart';

class ImageFeedWidget extends StatelessWidget {
  final dynamic feed;
  final Function() loaded;

  const ImageFeedWidget({
    Key key,
    @required this.feed,
    this.loaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.network(
        feed.url,
        fit: BoxFit.cover,
        loadingBuilder: (context, widget, event) {
          if (event == null) loaded();
          return event == null
              ? widget
              : Center(
                child: Image.asset(
                  'assets/icons/ic_logo.png',
                  color: Colors.white,
                  width: 120,
                  fit: BoxFit.fitWidth,
                ),
          );
        },
      ),
    );
  }
}
