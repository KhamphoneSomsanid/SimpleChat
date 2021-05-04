import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/models/room_model.dart';
import 'package:simplechat/screens/chat/chat_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/image_widget.dart';
import 'package:simplechat/widgets/user_widget.dart';

class UserScreen extends StatefulWidget {
  final dynamic user;

  const UserScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var userStatus = -1;
  var postCount = 0;
  var friendCount = 0;
  var reviewCount = 0;
  var followCount = 0;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getStatus();
    });
  }

  void _getStatus() async {
    var param = {
      'id': currentUser.id,
      'userid': widget.user.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_user_status', param, isProgress: true);
    if (resp['ret'] == 10000) {
      userStatus = resp['result']['status'] as int;
      postCount = resp['result']['posts'] as int;
      friendCount = resp['result']['friends'] as int;
      reviewCount = resp['result']['reviews'] as int;
      followCount = resp['result']['follows'] as int;
      setState(() {});
    }
  }

  Widget getContent(int type) {
    switch (type) {
      case 0:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: offsetBase),
          child: Row(
            children: [
              Spacer(),
              Text(
                'No Friend',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                width: offsetBase,
              ),
              InkWell(
                onTap: () {
                  _request();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetSm, vertical: offsetXSm),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.3),
                    border: Border.all(color: Colors.orange, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  ),
                  child: Text(
                    'Send Request',
                    style: regularText.copyWith(
                        fontSize: fontSm, color: Colors.orange),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        );
        break;
      case 1:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: offsetBase),
          child: Row(
            children: [
              Spacer(),
              Text(
                'Send Request',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                width: offsetBase,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: offsetSm, vertical: offsetXSm),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                ),
                child: Text(
                  'Waiting Accept',
                  style: regularText.copyWith(
                      fontSize: fontSm, color: Colors.grey),
                ),
              ),
              Spacer(),
            ],
          ),
        );
        break;
      case 2:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: offsetBase),
          child: Row(
            children: [
              Spacer(),
              Text(
                'Received Request',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                width: offsetBase,
              ),
              InkWell(
                onTap: () {
                  _accept();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetSm, vertical: offsetXSm),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    border: Border.all(color: Colors.green, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  ),
                  child: Text(
                    'Accept',
                    style: regularText.copyWith(
                        fontSize: fontSm, color: Colors.green),
                  ),
                ),
              ),
              SizedBox(
                width: offsetBase,
              ),
              InkWell(
                onTap: () {
                  _cancel();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetSm, vertical: offsetXSm),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    border: Border.all(color: Colors.red, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  ),
                  child: Text(
                    'Cancel',
                    style: regularText.copyWith(
                        fontSize: fontSm, color: Colors.red),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        );
        break;
      case 3:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: offsetBase),
          child: Row(
            children: [
              Spacer(),
              InkWell(
                onTap: () {
                  _chat();
                },
                child: CircleIconWidget(
                  icon: Icon(
                    Icons.chat,
                    color: Colors.green,
                    size: 20.0,
                  ),
                ),
              ),
              SizedBox(
                width: offsetLg,
              ),
              InkWell(
                onTap: () {
                  _voice();
                },
                child: CircleIconWidget(
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 20.0,
                  ),
                ),
              ),
              SizedBox(
                width: offsetLg,
              ),
              InkWell(
                onTap: () {
                  _video();
                },
                child: CircleIconWidget(
                  icon: Icon(
                    Icons.videocam,
                    color: Colors.green,
                    size: 20.0,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        );
        break;
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var aboutItems = [
      {
        'icon': Icon(Icons.account_box),
        'title': widget.user.username,
      },
      {
        'icon': Icon(Icons.email),
        'title': widget.user.email,
      },
      {
        'icon': Icon(Icons.calendar_today),
        'title': widget.user.birthday,
      },
      {
        'icon': Icon(Icons.pregnant_woman),
        'title': widget.user.gender,
      },
      {
        'icon': Icon(Icons.comment),
        'title': widget.user.comment,
      },
      {
        'icon': Icon(Icons.language),
        'title':
            widget.user.language.isEmpty ? 'English' : widget.user.language,
      },
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: MainBarWidget(
        titleString: widget.user.username,
        titleIcon: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: offsetBase,
              ),
              CircleAvatarWidget(
                headurl: widget.user.imgurl,
              ),
              SizedBox(
                height: offsetBase,
              ),
              getContent(userStatus),
              SizedBox(
                height: offsetBase,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserReviewCell(
                    icon: 'assets/icons/ic_post.svg',
                    title: 'Posts',
                    value: StringService.getCountValue(postCount),
                    color: Colors.green,
                  ),
                  UserReviewCell(
                    icon: 'assets/icons/ic_friend.svg',
                    title: 'Friends',
                    value: StringService.getCountValue(friendCount),
                    color: Colors.blue,
                  ),
                  UserReviewCell(
                    icon: 'assets/icons/ic_like.svg',
                    title: 'Likes',
                    value: StringService.getCountValue(reviewCount),
                    color: Colors.purple,
                  ),
                  UserReviewCell(
                    icon: 'assets/icons/ic_follow.svg',
                    title: 'Follows',
                    value: StringService.getCountValue(followCount),
                    color: Colors.red,
                  ),
                  if (appSettingInfo['isNearby'])
                    UserReviewCell(
                      icon: 'assets/icons/ic_project.svg',
                      title: 'Projects',
                      value: '2',
                      color: Colors.orange,
                    ),
                ],
              ),
              SizedBox(
                height: offsetBase,
              ),
              if (userStatus == 3)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(offsetBase)),
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: offsetMd, vertical: offsetBase),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(offsetBase)),
                        color: Colors.white),
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
            ],
          ),
        ),
      ),
    );
  }

  void _accept() async {
    var param = {
      'id': currentUser.id,
      'userid': widget.user.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_submit_accept', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);

      String roomID = '${resp['result']}';
      socketService.acceptRequest(widget.user.id, roomID);

      _getStatus();
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }

  void _cancel() async {
    var param = {
      'id': currentUser.id,
      'userid': widget.user.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_submit_cancel', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
      _getStatus();
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }

  void _request() async {
    var param = {
      'id': currentUser.id,
      'userid': widget.user.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_send_request', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
      socketService.sendRequest(widget.user.id);

      _getStatus();
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.WARING);
    }
  }

  void _chat() async {
    var param = {
      'id': currentUser.id,
      'userid': widget.user.id,
      'type': 'INDIVIAL'
    };

    var resp = await NetworkService(context)
        .ajax('chat_room_id', param, isProgress: true);
    if (resp['ret'] == 10000) {
      RoomModel model = RoomModel.fromMap(resp['result']);
      model.title = widget.user.username;
      model.imgurl = widget.user.imgurl;
      NavigatorService(context).pushToWidget(
          screen: ChatScreen(
        room: model,
      ));
    }
  }

  void _voice() async {
    if (!appSettingInfo['isVoiceCall']) {
      DialogService(context)
          .showSnackbar(notSupport, _scaffoldKey, type: SnackBarType.ERROR);
      return;
    }
  }

  void _video() async {
    if (!appSettingInfo['isVideoCall']) {
      DialogService(context)
          .showSnackbar(notSupport, _scaffoldKey, type: SnackBarType.ERROR);
      return;
    }
  }
}
