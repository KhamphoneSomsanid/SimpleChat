import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/models/post_model.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/image_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final ExtraPostModel model;

  const PostDetailScreen({Key key, @required this.model}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final PageController controller = PageController(initialPage: 0);
  List<Widget> contents = [];
  var pageIndex = 0;
  var selectedItem;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    for (var item in widget.model.list) {
      contents.add(_getContent(item));
    }

    selectedItem = widget.model.list[0];
  }

  _buildCircleIndicator() {
    return CirclePageIndicator(
      size: 18.0,
      selectedSize: 24.0,
      itemCount: widget.model.list.length,
      currentPageNotifier: _currentPageNotifier,
      dotColor: Colors.white,
      borderColor: primaryColor,
      selectedDotColor: primaryColor,
      selectedBorderColor: Colors.white,
      borderWidth: 3,
    );
  }

  Widget _getContent(MediaModel item) {
    switch (item.type) {
      case 'IMAGE':
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                item.url,
                fit: BoxFit.contain,
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

  void pageChangeByIndex(int index) {
    setState(() {
      pageIndex = index;
      controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(index) {
    setState(() {
      pageIndex = index;
      selectedItem = widget.model.list[pageIndex];
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: 66.0,
              color: Colors.black.withOpacity(0.7),
              padding: EdgeInsets.symmetric(
                  vertical: offsetSm, horizontal: offsetBase),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: EdgeInsets.only(right: offsetBase),
                        child: Icon(
                          Platform.isAndroid
                              ? Icons.arrow_back
                              : Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ),
                  CircleAvatarWidget(
                    headurl: widget.model.user.imgurl,
                    size: 44,
                  ),
                  SizedBox(
                    width: offsetBase,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.model.user.username,
                          style: semiBold.copyWith(
                              fontSize: fontBase, color: Colors.white),
                        ),
                        SizedBox(
                          height: offsetXSm,
                        ),
                        Text(
                          StringService.getCurrentTimeValue(
                              widget.model.post.regdate),
                          style: mediumText.copyWith(
                              fontSize: fontSm, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(offsetBase),
                height: 120,
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                for (var iconName in reviewIcons)
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 15 *
                                              double.parse(
                                                  '${reviewIcons.indexOf(iconName)}')),
                                      child: Image.asset(
                                        iconName,
                                        width: 24.0,
                                      )),
                              ],
                            ),
                            SizedBox(
                              width: offsetSm,
                            ),
                            Text(
                              '1.3 K',
                              style: mediumText.copyWith(
                                  fontSize: fontBase, color: Colors.white),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            CircleIconWidget(
                                size: 28.0,
                                padding: offsetSm,
                                color: Colors.white,
                                icon: SvgPicture.asset(
                                  'assets/icons/ic_chat.svg',
                                  width: 12,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              width: offsetSm,
                            ),
                            Text(
                              '1.3 K',
                              style: mediumText.copyWith(
                                  fontSize: fontBase, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: offsetBase,
                        ),
                        Row(
                          children: [
                            CircleIconWidget(
                                size: 28.0,
                                padding: offsetSm,
                                color: Colors.white,
                                icon: SvgPicture.asset(
                                  'assets/icons/ic_follow.svg',
                                  width: 12,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              width: offsetSm,
                            ),
                            Text(
                              '1.3 K',
                              style: mediumText.copyWith(
                                  fontSize: fontBase, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    DividerWidget(
                      padding: EdgeInsets.symmetric(vertical: offsetBase),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                // setLike();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleIconWidget(
                                    size: 28.0,
                                    padding: offsetSm,
                                    color: Colors.white,
                                    icon: SvgPicture.asset(
                                      'assets/icons/ic_like.svg',
                                      width: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetSm,
                                  ),
                                  Text(
                                    'Likes',
                                    style: mediumText.copyWith(
                                        fontSize: fontBase,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                // setComment();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleIconWidget(
                                    size: 28.0,
                                    padding: offsetSm,
                                    color: Colors.white,
                                    icon: Icon(
                                      Icons.comment_outlined,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetSm,
                                  ),
                                  Text(
                                    'Comments',
                                    style: mediumText.copyWith(
                                        fontSize: fontBase,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                widget.model.setFollow(context, _scaffoldKey);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleIconWidget(
                                    size: 28.0,
                                    padding: offsetSm,
                                    color: Colors.white,
                                    icon: Icon(
                                      Icons.share,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetSm,
                                  ),
                                  Text(
                                    'Follow',
                                    style: mediumText.copyWith(
                                        fontSize: fontBase,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
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
    );
  }
}
