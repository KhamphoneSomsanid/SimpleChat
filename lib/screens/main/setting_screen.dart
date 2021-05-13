import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simplechat/screens/auth/forgot_screen.dart';
import 'package:simplechat/screens/auth/login_screen.dart';
import 'package:simplechat/screens/post/follow_post_screen.dart';
import 'package:simplechat/screens/setting/app_info_screen.dart';
import 'package:simplechat/screens/setting/app_notification_screen.dart';
import 'package:simplechat/screens/setting/chat_setting_screen.dart';
import 'package:simplechat/screens/setting/friend_setting_screen.dart';
import 'package:simplechat/screens/setting/membership_screen.dart';
import 'package:simplechat/screens/setting/my_post_screen.dart';
import 'package:simplechat/screens/setting/privacy_screen.dart';
import 'package:simplechat/screens/setting/profile_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/label_widget.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var settingMenuData = [
    {
      'title': 'Post Management',
      'color': blueColor,
      'visible': true,
      'buttons': [
        {
          'icon': 'assets/icons/ic_post.svg',
          'title': 'My Post(s)',
          'actionWidget': MyPostScreen(),
        },
        {
          'icon': 'assets/icons/ic_link.svg',
          'title': 'Follow Post(s)',
          'actionWidget': FollowPostScreen(),
        },
      ],
    },
    {
      'title': 'Chat Management',
      'color': Colors.deepPurpleAccent,
      'visible': true,
      'buttons': [
        {
          'icon': 'assets/icons/ic_chat.svg',
          'title': 'Chat',
          'actionWidget': ChatSettingScreen(),
        },
        {
          'icon': 'assets/icons/ic_friend.svg',
          'title': 'Friend(s)',
          'actionWidget': FriendSettingScreen(),
        },
      ],
    },
    {
      'title': 'Nearby Management',
      'color': Colors.red,
      'visible': appSettingInfo['isNearby'],
      'buttons': [
        {
          'icon': 'assets/icons/ic_post.svg',
          'title': 'Nearby',
          'actionWidget': null,
        },
      ],
    },
    {
      'title': 'App Management',
      'color': Colors.orange,
      'visible': true,
      'buttons': [
        {
          'icon': 'assets/icons/ic_notification_on.svg',
          'title': 'Notification',
          'actionWidget': AppNotificationScreen(),
        },
        {
          'icon': 'assets/icons/ic_support.svg',
          'title': 'App Informaiton',
          'actionWidget': AppInfoScreen(),
        },
        {
          'icon': 'assets/icons/ic_empty.svg',
          'title': 'Privacy and Policy',
          'actionWidget': PrivacyScreen(),
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void showQRCode() {
    String encryptData = StringService.encryptString(currentUser.toJson());

    DialogService(context).showCustomDialog(
        titleWidget: Text('My QR Code',
          style: boldText.copyWith(fontSize: fontLg),),
        bodyWidget: Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.all(offsetBase),
          child: Center(
            child: QrImage(
              data: encryptData,
              version: QrVersions.auto,
              embeddedImage: AssetImage('assets/icons/ic_logo.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(80, 80),
              ),
              size: 250.0,
            ),
          ),
        ),
        bottomWidget: Container(
          padding: EdgeInsets.all(offsetBase),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(offsetBase),
                bottomRight: Radius.circular(offsetBase)),
          ),
          child: Row(
            children: [
              Spacer(),
              Container(
                width: 100, height: 40,
                child: FullWidthButton(
                  title: 'Dismiss',
                  color: Colors.red,
                  action: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
              SizedBox(
                width: offsetMd,
              ),
              Container(
                width: 100, height: 40,
                child: FullWidthButton(
                  title: 'Share',
                  action: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ));
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
        padding: EdgeInsets.symmetric(horizontal: offsetBase),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: offsetBase,
                  ),
                  OutLineLabel(title: 'User managment'),
                  SizedBox(
                    height: offsetSm,
                  ),
                  InkWell(
                      onTap: () {
                        NavigatorService(context).pushToWidget(
                            screen: ProfileScreen(),
                            pop: (value) {
                              setState(() {});
                            });
                      },
                      child: currentUser.itemSettingWidget()),
                  SizedBox(
                    height: offsetSm,
                  ),
                  InkWell(
                    onTap: () {
                      showQRCode();
                    },
                    child: SettingCellWidget(
                      icon: 'assets/icons/ic_qr_code.svg',
                      title: 'My QR Code',
                      textColor: primaryColor,
                    ),
                  ),
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
                ],
              ),
              for (var settingMenu in settingMenuData)
                if (settingMenu['visible'])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutLineLabel(
                        title: settingMenu['title'],
                        titleColor: settingMenu['color'],
                      ),
                      for (var button in settingMenu['buttons'])
                        Column(
                          children: [
                            SizedBox(
                              height: offsetSm,
                            ),
                            InkWell(
                              onTap: () {
                                if (button['actionWidget'] != null) {
                                  NavigatorService(context).pushToWidget(
                                      screen: button['actionWidget']);
                                }
                              },
                              child: SettingCellWidget(
                                icon: button['icon'],
                                title: button['title'],
                                textColor: settingMenu['color'],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: offsetBase,
                      ),
                    ],
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
