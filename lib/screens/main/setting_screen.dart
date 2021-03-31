import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/screens/auth/forgot_screen.dart';
import 'package:simplechat/screens/auth/login_screen.dart';
import 'package:simplechat/screens/setting/membership_screen.dart';
import 'package:simplechat/screens/setting/my_post_screen.dart';
import 'package:simplechat/screens/setting/profile_screen.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/label_widget.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var postCount = 0;
  var roomCount = 0;
  var friendCount = 0;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _getData();
    });
  }

  void _getData() async {
    var param = {
      'id': currentUser.id,
    };
    var resp = await NetworkService(null)
        .ajax('chat_setting', param, isProgress: true);
    if (resp['ret'] == 10000) {
      postCount = resp['result']['posts'];
      roomCount = resp['result']['rooms'];
      friendCount = resp['result']['friends'];

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleIcon: Container(
          padding: EdgeInsets.all(offsetBase),
          child: SvgPicture.asset(
            'assets/icons/ic_setting.svg',
            color: primaryColor,
          ),
        ),
        titleString: 'Setting',
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logout();
              }),
        ],
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutLineLabel(title: 'User managment'),
              SizedBox(
                height: offsetSm,
              ),
              InkWell(
                  onTap: () {
                    NavigatorService(context)
                        .pushToWidget(screen: ProfileScreen());
                  },
                  child: currentUser.itemSettingWidget()),
              SizedBox(
                height: offsetSm,
              ),
              InkWell(
                onTap: () {
                  NavigatorService(context).pushToWidget(
                    screen: ForgotPassScreen(
                      title: 'Change Password',
                    ),
                  );
                },
                child: SettingCellWidget(
                  icon: 'assets/icons/ic_secret.svg',
                  title: 'Change Password',
                  textColor: primaryColor,
                ),
              ),
              if (appSettingInfo['isNearby'])
                SizedBox(
                  height: offsetSm,
                ),
              if (appSettingInfo['isNearby'])
                InkWell(
                  onTap: () {
                    NavigatorService(context).pushToWidget(
                        screen: MemberShipScreen(),
                        pop: (value) {
                          setState(() {});
                        });
                  },
                  child: SettingCellWidget(
                    icon: 'assets/icons/ic_membership.svg',
                    title: 'Membership',
                    detail: currentUser.expiredate.split(' ')[0],
                    textColor: primaryColor,
                  ),
                ),
              SizedBox(
                height: offsetBase,
              ),
              OutLineLabel(
                title: 'Posts managment',
                titleColor: blueColor,
              ),
              SizedBox(
                height: offsetSm,
              ),
              InkWell(
                onTap: () {
                  NavigatorService(context)
                      .pushToWidget(screen: MyPostScreen());
                },
                child: SettingCellWidget(
                  icon: 'assets/icons/ic_post.svg',
                  title: 'My Post(s)',
                  detail: StringService.getCountValue(postCount),
                  textColor: blueColor,
                ),
              ),
              SizedBox(
                height: offsetSm,
              ),
              SettingCellWidget(
                icon: 'assets/icons/ic_post.svg',
                title: 'Follow Post(s)',
                textColor: blueColor,
              ),
              SizedBox(
                height: offsetBase,
              ),
              OutLineLabel(
                title: 'Chat managment',
                titleColor: Colors.deepPurpleAccent,
              ),
              SizedBox(
                height: offsetSm,
              ),
              SettingCellWidget(
                icon: 'assets/icons/ic_chat.svg',
                title: 'Chat',
                detail: StringService.getCountValue(roomCount),
                textColor: Colors.deepPurpleAccent,
              ),
              SizedBox(
                height: offsetSm,
              ),
              SettingCellWidget(
                icon: 'assets/icons/ic_friend.svg',
                title: 'Friend(s)',
                detail: StringService.getCountValue(friendCount),
                textColor: Colors.deepPurpleAccent,
              ),
              SizedBox(
                height: offsetBase,
              ),
              if (appSettingInfo['isNearby'])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutLineLabel(
                      title: 'Nearby managment',
                      titleColor: Colors.red,
                    ),
                    SizedBox(
                      height: offsetSm,
                    ),
                    SettingCellWidget(
                      icon: 'assets/icons/ic_post.svg',
                      title: 'Nearby',
                      textColor: Colors.red,
                    ),
                    SizedBox(
                      height: offsetBase,
                    ),
                  ],
                ),
              OutLineLabel(
                title: 'App management',
                titleColor: Colors.orange,
              ),
              SizedBox(
                height: offsetSm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    var param = {
      'id': currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_logout', param, isProgress: true);
    if (resp['ret'] == 10000) {
      NavigatorService(context).pushToWidget(screen: LoginScreen());
    }
  }
}
