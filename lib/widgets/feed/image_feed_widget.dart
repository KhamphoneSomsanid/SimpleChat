import 'dart:io';

import 'package:flutter/material.dart';

class ImageFeedWidget extends StatelessWidget {
  final dynamic feed;
  final File file;
  final Function() loaded;

  const ImageFeedWidget({
    Key key,
    this.feed,
    this.file,
    this.loaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: feed == null
          ? Image.file(
          file,
          fit: BoxFit.cover,
        )
          : Image.network(
        feed.url,
        fit: BoxFit.cover,
        loadingBuilder: (context, widget, event) {
          if (event == null && loaded != null) loaded();
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
