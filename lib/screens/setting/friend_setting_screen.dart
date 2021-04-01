import 'package:flutter/material.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';

class FriendSettingScreen extends StatefulWidget {
  @override
  _FriendSettingScreenState createState() => _FriendSettingScreenState();
}

class _FriendSettingScreenState extends State<FriendSettingScreen> {
  var screenData = [
    {
      'title': 'Allow Request Notification',
      'desc':
          'This feature is a allow permission when user send a friend request to you.',
    },
    {
      'title': 'Allow Accept Notification',
      'desc':
          'This feature is a allow permission when user accept your friend request.',
    },
  ];

  bool requestValue = true;
  bool acceptValue = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    requestValue = await PreferenceService().getRequestNotification();
    acceptValue = await PreferenceService().getFriendNotification();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Friend Setting',
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
        child: Column(
          children: [
            CustomSwitchWidget(
                title: screenData[0]['title'],
                description: screenData[0]['desc'],
                switchValue: requestValue,
                action: () {
                  setState(() {
                    requestValue = !requestValue;
                  });
                  PreferenceService().setRequestNotification(requestValue);
                }),
            DividerWidget(
              padding: EdgeInsets.symmetric(vertical: offsetBase),
            ),
            CustomSwitchWidget(
                title: screenData[1]['title'],
                description: screenData[1]['desc'],
                switchValue: acceptValue,
                action: () {
                  setState(() {
                    acceptValue = !acceptValue;
                  });
                  PreferenceService().setFriendNotification(acceptValue);
                }),
          ],
        ),
      ),
    );
  }
}
