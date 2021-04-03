import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/feed/image_feed_widget.dart';
import 'package:simplechat/widgets/feed/text_feed_widget.dart';
import 'package:simplechat/widgets/feed/video_feed_widget.dart';
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
  int animationTime = 5000;
  double percent = 0.0;

  bool isLoading = true;
  bool isAnimation = false;

  @override
  void initState() {
    super.initState();

    _addContent();
  }

  void _addContent() async {
    for (var item in widget.list) {
      contents.add(await _getContent(item));
    }
    pageChanged(0);
  }

  void _startTimer() {
    if (timer != null) {
      timer.cancel();
    }
    setState(() {
      isLoading = false;
      isAnimation = true;
      animationTime = 5000;
    });
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

  Future<Widget> _getContent(dynamic item) async {
    switch (item.type) {
      case 'TEXT':
        return TextFeedWidget(
          feed: item,
          loaded: () {
              // _startTimer();
          },
        );
      case 'IMAGE':
        return ImageFeedWidget(
          feed: item,
          loaded: () {
              // _startTimer();
          },
        );
      case 'VIDEO':
        return VideoFeedWidget(
            feed: item,
          loaded: () {
            pageChangeToNext();
          },
          loading: (value) {
            setState(() {
              percent = value;
            });
          },
          willPlay: (value) {
            setState(() {
              isAnimation = false;
              animationTime = value;
              isLoading = false;
            });
          },
        );
    }
    return Container();
  }

  void pageChanged(index) {
    if (widget.list[index].type != 'VIDEO') {
      _startTimer();
    }
    setState(() {
      pageIndex = index;
      selectedItem = widget.list[pageIndex];
    });
  }

  void pageChangeByIndex(int index) {
    setState(() {
      isLoading = true;
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
    if (controller != null) controller.dispose();
    if (timer != null) timer.cancel();

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
              if (contents.isNotEmpty) PageView(
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
                        if (!isLoading) CircularPercentIndicator(
                          radius: 48.0,
                          lineWidth: 3.0,
                          animationDuration: animationTime,
                          percent: isAnimation? 1.0 : percent,
                          animation: isAnimation,
                          progressColor: primaryColor,
                          backgroundColor: Colors.white,
                          onAnimationEnd: () {
                            setState(() {
                              isLoading = true;
                            });
                          },
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
                                  selectedItem == null? '' : selectedItem.regdate),
                              style: semiBold.copyWith(
                                  fontSize: fontMd, color: Colors.white),
                            ),
                            Text(
                              selectedItem == null? '' : selectedItem.content,
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
