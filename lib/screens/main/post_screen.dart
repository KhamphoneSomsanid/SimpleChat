import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simplechat/models/post_model.dart';
import 'package:simplechat/models/story_model.dart';
import 'package:simplechat/screens/main/noti_screen.dart';
import 'package:simplechat/screens/post/comment_screen.dart';
import 'package:simplechat/screens/post/follow_screen.dart';
import 'package:simplechat/screens/post/post_detail_screen.dart';
import 'package:simplechat/screens/post/review_screen.dart';
import 'package:simplechat/screens/setting/user_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/story_widget.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ExtraStoryModel> stories = [];
  List<ExtraPostModel> posts = [];

  bool isUpdating = false;
  var limitCount = 20;
  var newFeedAccount = 0;
  var isFriendMenu = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getData();
    });

    preLoadData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void preLoadData() async {
    newFeedAccount = await PreferenceService().getNewFeed();
    stories.clear();
    stories = await PreferenceService().getStoryData();

    posts.clear();
    posts = await PreferenceService().getPostData();

    isFriendMenu = false;

    setState(() {});
  }

  void _getData() async {
    var param = {
      'userid': currentUser.id,
      'limit': '$limitCount',
    };

    setState(() {
      isUpdating = true;
    });

    var resp = await NetworkService(context)
        .ajax('chat_post', param, isProgress: false);

    stories.clear();
    for (var storyJson in resp['stories']) {
      ExtraStoryModel model = ExtraStoryModel.fromMap(storyJson);
      stories.add(model);
    }
    stories.sort((b, a) => a.list.last.regdate.compareTo(b.list.last.regdate));
    await PreferenceService().setStoryData(stories);

    posts.clear();
    for (var storyJson in resp['posts']) {
      ExtraPostModel model = ExtraPostModel.fromMap(storyJson);
      posts.add(model);
    }
    posts.sort((b, a) => a.post.regdate.compareTo(b.post.regdate));
    await PreferenceService().setPostData(posts);

    if (_refreshController != null) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }

    setState(() {
      isFriendMenu = false;
      isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MainBarWidget(
        titleIcon: Container(
          padding: EdgeInsets.all(offsetBase),
          child: SvgPicture.asset(
            'assets/icons/ic_post.svg',
            color: primaryColor,
          ),
        ),
        titleString: 'Posts',
        actions: [
          if (appSettingInfo['isNearby'])
            IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/ic_notification_on.svg',
                  color: primaryColor,
                ),
                onPressed: () {
                  NavigatorService(context).pushToWidget(screen: NotiScreen());
                }),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: posts.length == limitCount,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _getData,
        onLoading: () {
          if (limitCount == posts.length) limitCount = limitCount + 10;
          _getData();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: offsetXSm),
            child: Column(
              children: [
                UpdateWidget(
                  isUpdating: isUpdating,
                  title: 'Updating now ...',
                ),
                StoryWidget(
                  stories: stories,
                  refresh: () {
                    _getData();
                  },
                ),
                if (newFeedAccount > 0)
                  InkWell(
                    onTap: () {
                      _getData();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: offsetSm),
                      padding: EdgeInsets.symmetric(
                          vertical: offsetXSm, horizontal: offsetBase),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.5),
                        border: Border.all(color: Colors.green),
                        borderRadius:
                            BorderRadius.all(Radius.circular(offsetBase)),
                      ),
                      child: Text(
                        'New Feeds ($newFeedAccount)',
                        style: semiBold.copyWith(
                            fontSize: fontBase, color: Colors.white),
                      ),
                    ),
                  ),
                for (var post in posts)
                  post.item(toUserDtail: () {
                    if (post.user.id == currentUser.id) {
                      DialogService(context).showSnackbar(
                          'This is a your account. You can check the status on setting.',
                          _scaffoldKey,
                          type: SnackBarType.WARING);
                      return;
                    }
                    NavigatorService(context)
                        .pushToWidget(screen: UserScreen(user: post.user));
                  }, toDtail: () {
                    if (post.list.isEmpty) {
                      DialogService(context).showSnackbar(
                          'This is a text feed so that you can\'t see detail.',
                          _scaffoldKey,
                          type: SnackBarType.WARING);
                      return;
                    }
                    NavigatorService(context).pushToWidget(
                        screen: PostDetailScreen(post: post),
                        pop: (val) {
                          _getData();
                        });
                  }, toLike: () {
                    NavigatorService(context).pushToWidget(
                        screen: ReviewScreen(postid: post.post.id));
                  }, toComment: () {
                    NavigatorService(context).pushToWidget(
                        screen: CommentScreen(
                          model: post,
                        ),
                        pop: (value) {
                          _getData();
                        });
                  }, toFollow: () {
                    NavigatorService(context).pushToWidget(
                      screen: FollowScreen(
                        postid: post.post.id,
                      ),
                    );
                  }, setLike: (offset) {
                    DialogService(context).showLikePopupMenu(offset,
                        setLike: (value) async {
                      Navigator.of(context).pop();
                      await post.setLike(context, _scaffoldKey, value);
                      _getData();
                    });
                  }, setComment: () {
                    NavigatorService(context).pushToWidget(
                        screen: CommentScreen(
                          model: post,
                        ),
                        pop: (value) {
                          _getData();
                        });
                  }, setFollow: () async {
                    await post.setFollow(context, _scaffoldKey);
                    _getData();
                  }),
                SizedBox(
                  height: offsetLg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
