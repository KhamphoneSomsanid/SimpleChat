import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

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
  var pageIndex = 0;
  var selectedItem;
  Timer timer;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    for (var item in widget.list) {
      contents.add(_getContent(item));
    }

    selectedItem = widget.list[0];
    _startTimer();
  }

  void _startTimer() {
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer(const Duration(seconds: 5), () {
      pageChangeToNext();
    });
  }

  _buildCircleIndicator() {
    return CirclePageIndicator(
      size: 18.0,
      selectedSize: 24.0,
      itemCount: widget.list.length,
      currentPageNotifier: _currentPageNotifier,
      dotColor: Colors.white,
      borderColor: primaryColor,
      selectedDotColor: primaryColor,
      selectedBorderColor: Colors.white,
      borderWidth: 3,
    );
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
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                item.url,
                fit: BoxFit.cover,
                loadingBuilder: (context, widget, event) {
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
            ),
          ],
        );
    }
    return Container();
  }

  void pageChanged(index) {
    if (!timer.isActive) {
      _startTimer();
    }
    setState(() {
      pageIndex = index;
      selectedItem = widget.list[pageIndex];
    });
  }

  void pageChangeByIndex(int index) {
    setState(() {
      pageIndex = index;
      controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChangeToNext() {
    if (widget.list.length == pageIndex + 1) {
      Navigator.of(context).pop();
      return;
    }
    pageChangeByIndex(pageIndex + 1);
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (timer != null) {
          timer.cancel();
        }
        pageChangeToNext();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: getGradientColor(color: getRandomColor()),
          ),
          child: Stack(
            children: [
              PageView(
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  _currentPageNotifier.value = index;
                  pageChanged(index);
                },
                controller: controller,
                children: contents,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(right: offsetLg, top: offsetXLg * 2),
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    ),
                    child: Stack(
                      children: [
                        Center(
                            child: Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                        CircularPercentIndicator(
                          radius: 48.0,
                          lineWidth: 3.0,
                          animationDuration: 5000,
                          percent: 1.0,
                          animation: true,
                          restartAnimation: true,
                          progressColor: primaryColor,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: offsetXLg),
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetBase, vertical: offsetSm),
                  height: 90,
                  child: Row(
                    children: [
                      CircleAvatarWidget(
                        headurl: widget.user.imgurl,
                        size: 60,
                      ),
                      SizedBox(
                        width: offsetBase,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringService.getCurrentTimeValue(
                                  selectedItem.regdate),
                              style: semiBold.copyWith(
                                  fontSize: fontMd, color: Colors.white),
                            ),
                            Text(
                              selectedItem.content,
                              style: semiBold.copyWith(
                                  fontSize: fontMd, color: Colors.white),
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: offsetSm,
                            ),
                            Text(
                              widget.user.username,
                              style: boldText.copyWith(
                                  fontSize: fontLg, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: offsetXLg * 2 + 90),
                  child: _buildCircleIndicator(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
