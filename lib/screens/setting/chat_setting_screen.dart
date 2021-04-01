import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';

class ChatSettingScreen extends StatefulWidget {
  @override
  _ChatSettingScreenState createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  var _switchNotificationValue = true;
  var _notificationBadge = true;

  @override
  void initState() {
    super.initState();

    initData();
  }

  void initData() async {
    _switchNotificationValue = await PreferenceService().getChatNotification();
    _notificationBadge = await PreferenceService().getChatBadge();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Chat Setting',
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
        child: Column(
          children: [
            CustomSwitchWidget(
                title: 'Allow Notification',
                description:
                    'This feature is allow notification when you are away for unready messages.',
                switchValue: _switchNotificationValue,
                action: () {
                  setState(() {
                    _switchNotificationValue = !_switchNotificationValue;
                  });
                  PreferenceService()
                      .setChatNotification(_switchNotificationValue);
                }),
            DividerWidget(
              padding: EdgeInsets.symmetric(vertical: offsetBase),
            ),
            CustomSwitchWidget(
                title: 'Allow Badge',
                description:
                    'This feature is allow badge when you are away for unready messages.',
                switchValue: _notificationBadge,
                action: () {
                  setState(() {
                    _notificationBadge = !_notificationBadge;
                  });
                  PreferenceService().setChatBadge(_notificationBadge);
                }),
          ],
        ),
      ),
    );
  }
}
