import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/models/post_model.dart';
import 'package:simplechat/screens/post/comment_screen.dart';
import 'package:simplechat/screens/post/follow_screen.dart';
import 'package:simplechat/screens/post/review_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/feed/image_feed_widget.dart';
import 'package:simplechat/widgets/feed/video_feed_widget.dart';
import 'package:simplechat/widgets/image_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final ExtraPostModel post;

  const PostDetailScreen({Key key, @required this.post}) : super(key: key);

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

  ExtraPostModel model;

  @override
  void initState() {
    super.initState();

    model = widget.post;
    initContent();

    selectedItem = model.list[0];
  }

  void initContent() {
    contents.clear();
    for (var item in model.list) {
      contents.add(_getContent(item));
    }
    setState(() {});
  }

  _buildCircleIndicator() {
    return CirclePageIndicator(
      size: 18.0,
      selectedSize: 24.0,
      itemCount: model.list.length,
      currentPageNotifier: _currentPageNotifier,
      dotColor: Colors.white,
      borderColor: primaryColor,
      selectedDotColor: primaryColor,
      selectedBorderColor: Colors.white,
      borderWidth: 3,
    );
  }

  void _getData() async {
    var param = {
      'postid' : model.post.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_post_id', param, isProgress: true);
    if (resp['ret'] == 10000) {
      model = ExtraPostModel.fromMap(resp['result']);
      initContent();
    }
  }

  Widget _getContent(MediaModel item) {
    switch (item.type) {
      case 'IMAGE':
        return ImageFeedWidget(feed: item,);
      case 'VIDEO':
        return VideoFeedWidget(feed: item,);
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
      selectedItem = model.list[pageIndex];
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
              color: Colors.black.withOpacity(0.5),
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
                    headurl: model.user.imgurl,
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
                          model.user.username,
                          style: semiBold.copyWith(
                              fontSize: fontBase, color: Colors.white),
                        ),
                        SizedBox(
                          height: offsetXSm,
                        ),
                        Text(
                          StringService.getCurrentTimeValue(
                              model.post.regdate),
                          style: mediumText.copyWith(
                              fontSize: fontSm, color: Colors.white),
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
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                padding: EdgeInsets.all(offsetBase),
                height: 120,
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ReviewGroupWidget(
                          reviews: model.reviews,
                          titleColor: Colors.white,
                          toLike: () {
                            NavigatorService(context).pushToWidget(screen: ReviewScreen(postid: widget.post.post.id));
                          },
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            NavigatorService(context).pushToWidget(
                                screen: CommentScreen(model: model),
                                pop: (val) {
                                  _getData();
                                }
                            );
                          },
                          child: Row(
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
                                StringService.getCountValue(model.comments.length),
                                style: mediumText.copyWith(
                                    fontSize: fontBase, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: offsetBase,
                        ),
                        InkWell(
                          onTap: () {
                            NavigatorService(context).pushToWidget(screen: FollowScreen(postid: model.post.id));
                          },
                          child: Row(
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
                                  StringService.getCountValue(model.follows.length),
                                style: mediumText.copyWith(
                                    fontSize: fontBase, color: Colors.white),
                              ),
                            ],
                          ),
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
                            child: GestureDetector(
                              onTapDown: (details) {
                                DialogService(context).showLikePopupMenu(
                                  details.globalPosition,
                                  setLike: (val) async {
                                    Navigator.of(context).pop();
                                    await model.setLike(context, _scaffoldKey, val);
                                    _getData();
                                  }
                                );
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
                                NavigatorService(context).pushToWidget(
                                    screen: CommentScreen(model: model),
                                  pop: (val) {
                                      _getData();
                                  }
                                );
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
                                model.setFollow(context, _scaffoldKey);
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
