import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/models/story_model.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/story_widget.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> stories = [];

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getData();
    });
  }

  void _getData() async {
    var param = {
      'userid': currentUser.id,
    };

    setState(() {
      isUpdating = true;
    });

    var resp = await NetworkService(context)
        .ajax('chat_post', param, isProgress: false);

    stories.clear();
    stories =
        (resp['stories'].map((item) => ExtraStoryModel.fromMap(item)).toList());
    stories.sort((b, a) => a.list.last.regdate.compareTo(b.list.last.regdate));

    isUpdating = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleIcon: Container(
          padding: EdgeInsets.all(offsetBase),
          child: SvgPicture.asset(
            'assets/icons/ic_post.svg',
            color: primaryColor,
          ),
        ),
        titleString: 'Posts',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: offsetXSm),
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isUpdating ? 48 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: offsetSm),
                padding: EdgeInsets.symmetric(
                    vertical: offsetSm, horizontal: offsetBase),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  gradient: getGradientColor(color: blueColor),
                ),
                child: Text(
                  'Updating now...',
                  style:
                      semiBold.copyWith(fontSize: fontSm, color: Colors.white),
                ),
              ),
            ),
            StoryWidget(
              stories: stories,
              refresh: () {
                _getData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
