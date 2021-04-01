import 'package:flutter/material.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';

class AppNotificationScreen extends StatefulWidget {
  @override
  _AppNotificationScreenState createState() => _AppNotificationScreenState();
}

class _AppNotificationScreenState extends State<AppNotificationScreen> {

  var _postNotification = true;
  var _jobNotification = true;

  @override
  void initState() {
    super.initState();

    initData();
  }

  void initData() async {
    _postNotification = await PreferenceService().getPostNotification();
    _jobNotification = await PreferenceService().getJobNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'App Notification',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
        child: Column(
          children: [
            CustomSwitchWidget(
                title: 'Allow Post Notification',
                description:
                'This feature is allow permission when your friend post a feed.',
                switchValue: _postNotification,
                action: () {
                  setState(() {
                    _postNotification = !_postNotification;
                  });
                  PreferenceService()
                      .setPostNotification(_postNotification);
                }),
            DividerWidget(
              padding: EdgeInsets.symmetric(vertical: offsetBase),
            ),
            CustomSwitchWidget(
                title: 'Allow Job Notification',
                description:
                'This feature is allow permission when your friend post a job.',
                switchValue: _jobNotification,
                action: () {
                  setState(() {
                    _jobNotification = !_jobNotification;
                  });
                  PreferenceService()
                      .setJobNotification(_jobNotification);
                }),
          ],
        ),
      ),
    );
  }
}
