import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info/package_info.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoScreen extends StatefulWidget {
  @override
  _AppInfoScreenState createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    InAppReview.instance.requestReview();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'App Informations',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase),
        child: Column(
          children: [
            SizedBox(height: offsetBase,),
            cellWidget('App Name', _packageInfo.appName),
            cellWidget('Package Name', _packageInfo.packageName),
            cellWidget('Version', _packageInfo.version),
            cellWidget('Build Version', _packageInfo.buildNumber),
            InkWell(
              onTap: () {
                String url;
                if (Platform.isIOS) {
                  url = 'https://apps.apple.com/us/app/Simple Chat 2021/id1560156953';
                } else {
                  url = 'https://play.google.com/store/apps/details?id=${_packageInfo.packageName}';
                }
                launch(url);
              },
                child: cellWidget('App Store Link', Platform.isIOS? 'Apple' : 'Google')
            ),
            InkWell(
              onTap: () {
                final Uri _emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: appSettingInfo['contactEmail'],
                    queryParameters: {
                      'subject': 'Contact us'
                    }
                );
                launch(_emailLaunchUri.toString());
              },
                child: cellWidget('Support Email', appSettingInfo['contactEmail'])
            ),
            InkWell(
              onTap: () {
                launch('tel:${appSettingInfo['contactPhone']}');
              },
                child: cellWidget('Support Mobile', appSettingInfo['contactPhone'])
            ),
            SizedBox(height: offsetBase,),
          ],
        ),
      ),
    );
  }

  Widget cellWidget(String title, String value) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: offsetBase, horizontal: offsetSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: semiBold.copyWith(fontSize: fontBase),),
              Text(value, style: mediumText.copyWith(fontSize: fontBase),),
            ],
          ),
        ),
        DividerWidget(),
      ],
    );
  }
}
