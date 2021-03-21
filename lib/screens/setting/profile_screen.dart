import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simplechat/screens/setting/friend_list_screen.dart';
import 'package:simplechat/screens/setting/invite_screen.dart';
import 'package:simplechat/screens/setting/request_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var aboutItems = [
    {
      'icon': Icon(Icons.account_box),
      'title': currentUser.username,
    },
    {
      'icon': Icon(Icons.email),
      'title': currentUser.email,
    },
    {
      'icon': Icon(Icons.calendar_today),
      'title': currentUser.birthday,
    },
    {
      'icon': Icon(Icons.pregnant_woman),
      'title': currentUser.gender,
    },
    {
      'icon': Icon(Icons.comment),
      'title': currentUser.comment,
    },
  ];

  var friendCount = '';
  var requestCount = '';
  var isRequestBadge = false;
  var isFriendBadge = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getRelate();
    });
  }

  _getRelate() async {
    isRequestBadge = await PreferenceService().getRequestBadge();
    isFriendBadge = await PreferenceService().getFriendBadge();

    var param = {
      'id' : currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_user_releate', param, isProgress: true);
    if (resp['ret'] == 10000) {
      friendCount = '(${resp['result']['friend'] as int})';
      requestCount = '(${resp['result']['request'] as int})';
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool scrolled) {
        return [
          SliverAppBar(
            expandedHeight: 250.0,
            brightness: Brightness.dark,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  if (Platform.isIOS) SizedBox(width: 48.0,),
                  Expanded(
                    child: Text(
                      currentUser.username,
                      style: boldText.copyWith(
                          fontSize: fontXLg, color: Colors.white),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: offsetBase,
                  ),
                  Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: offsetBase,
                  ),
                ],
              ),
              background: CircleAvatarWidget(
                headurl: currentUser.imgurl,
                size: 36.0,
              ),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(offsetBase),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(offsetSm)),
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetMd, vertical: offsetBase),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          NavigatorService(context).pushToWidget(
                              screen: FriendListScreen(), pop: (val) async {
                            await PreferenceService().setFriendBadge(false);
                            setState(() {
                              isFriendBadge = false;
                            });
                          });
                        },
                        child: Row(
                          children: [
                            if (isFriendBadge) Container(
                              width: 8.0, height: 8.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                            if (isFriendBadge) SizedBox(width: offsetXSm,),
                            Text(
                              'Friends $friendCount',
                              style: semiBold.copyWith(
                                  fontSize: fontMd, color: blueColor,
                                  decoration: TextDecoration.underline
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigatorService(context)
                              .pushToWidget(screen: RequestScreen(),
                            pop: (value) async {
                              await PreferenceService().setRequestBadge(false);
                                _getRelate();
                            }
                          );
                        },
                        child: Row(
                          children: [
                            if (isRequestBadge) Container(
                              width: 8.0, height: 8.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                            if (isRequestBadge) SizedBox(width: offsetXSm,),
                            Text(
                              'Request $requestCount',
                              style: semiBold.copyWith(
                                  fontSize: fontMd, color: blueColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigatorService(context)
                              .pushToWidget(screen: InviteScreen(),
                            pop: (value) {
                                _getRelate();
                            }
                          );
                        },
                        child: Text(
                          'Invite',
                          style: semiBold.copyWith(
                              fontSize: fontMd, color: blueColor,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: offsetBase,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(offsetSm)),
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetMd, vertical: offsetBase),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: boldText.copyWith(
                          fontSize: fontMd,
                        ),
                      ),
                      for (var item in aboutItems)
                        Container(
                          padding: EdgeInsets.symmetric(vertical: offsetBase),
                          child: Row(
                            children: [
                              item['icon'],
                              SizedBox(
                                width: offsetBase,
                              ),
                              Text(
                                item['title'],
                                style: semiBold.copyWith(fontSize: fontBase),
                              ),
                              Spacer(),
                              Icon(
                                Icons.edit,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: offsetBase,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(offsetSm)),
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetMd, vertical: offsetBase),
                  child: Row(
                    children: [
                      Icon(Icons.language),
                      SizedBox(
                        width: offsetBase,
                      ),
                      Text(
                        currentUser.language.isEmpty
                            ? 'English'
                            : currentUser.language,
                        style: semiBold.copyWith(fontSize: fontBase),
                      ),
                      Spacer(),
                      Icon(
                        Icons.edit,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: offsetBase,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
