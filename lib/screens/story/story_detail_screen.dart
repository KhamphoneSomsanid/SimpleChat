import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class StoryDetailScreen extends StatefulWidget {
  final List<dynamic> list;
  final dynamic user;

  const StoryDetailScreen({
    Key key,
    @required this.list,
    @required this.user,
  });

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final PageController controller = PageController(initialPage: 0);

  List<Widget> contents = [];

  @override
  void initState() {
    super.initState();

    for (var item in widget.list) {
      contents.add(_getContent(item));
    }
  }

  Widget _getContent(dynamic item) {
    switch (item.type) {
      case 'TEXT':
        return Container(
          child: Center(
            child: Text(
              item.content,
              style: semiBold.copyWith(fontSize: fontLg, color: Colors.white),
            ),
          ),
        );
      case 'IMAGE':
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Image.network(
                item.url,
                fit: BoxFit.cover,
                loadingBuilder: (context, widget, event) {
                  return event == null
                      ? widget
                      : Center(
                          child: Image.asset(
                            'assets/icons/ic_logo.png',
                            color: Colors.grey,
                            width: 60,
                            fit: BoxFit.fitWidth,
                          ),
                        );
                },
              ),
              Align(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  color: Colors.black.withOpacity(0.7),
                  width: double.infinity,
                  height: 90,
                  child: Row(
                    children: [
                      CircleAvatarWidget(
                        headurl: item.imgurl,
                        size: 60,
                      ),
                      Column(
                        children: [
                          Text(widget.)
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
    }
    return Container();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: getGradientColor(color: getRandomColor()),
        ),
        child: Stack(
          children: [
            PageView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              children: contents,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(left: offsetLg, top: offsetXLg * 2),
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                ),
                child: Center(
                  child: Icon(
                    Platform.isIOS ? Icons.arrow_back : Icons.arrow_back,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
