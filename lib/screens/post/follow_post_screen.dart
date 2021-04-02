import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/models/post_model.dart';
import 'package:simplechat/screens/post/post_detail_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class FollowPostScreen extends StatefulWidget {
  @override
  _FollowPostScreenState createState() => _FollowPostScreenState();
}

class _FollowPostScreenState extends State<FollowPostScreen> {
  var searchController = TextEditingController();

  List<ExtraPostModel> posts = [];
  List<ExtraPostModel> showPosts = [];

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getData();
    });

    searchController.addListener(() {
      _filterData();
    });
  }

  void _getData() async {
    var param = {
      'userid': currentUser.id,
      'limit': '20',
    };
    var resp = await NetworkService(context)
        .ajax('chat_follow_post', param, isProgress: true);
    if (resp['ret'] == 10000) {
      posts.clear();
      for (var postJson in resp['result']) {
        ExtraPostModel model = ExtraPostModel.fromMap(postJson);
        posts.add(model);
      }
      posts.sort((b, a) => a.post.regdate.compareTo(b.post.regdate));

      _filterData();
    }
  }

  void _filterData() {
    String search = searchController.text;
    showPosts.clear();
    for (var post in posts) {
      if (post.isContainKey(search)) {
        showPosts.add(post);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: MainBarWidget(
          titleString: 'Follow Posts',
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
          child: Column(
            children: [
              SearchWidget(
                searchController: searchController,
                onClear: () {
                  setState(() {
                    searchController.text = '';
                  });
                },
                onChanged: (value) {},
              ),
              SizedBox(
                height: offsetSm,
              ),
              Expanded(
                child: showPosts.isEmpty
                    ? EmptyWidget(
                        title:
                            'You didn\'t post any feed yet. Please post some feed.',
                      )
                    : GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: offsetXSm,
                        mainAxisSpacing: offsetXSm,
                        childAspectRatio: 4 / 5,
                        children:
                            List<Widget>.generate(showPosts.length, (index) {
                          return showPosts[index].followItem(action: () {
                            NavigatorService(context).pushToWidget(
                                screen:
                                    PostDetailScreen(post: showPosts[index]));
                          });
                        }),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
