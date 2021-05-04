import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpgradeScreen extends StatefulWidget {
  @override
  _AppUpgradeScreenState createState() => _AppUpgradeScreenState();
}

class _AppUpgradeScreenState extends State<AppUpgradeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
          child: Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                'assets/icons/ic_upgrade.svg',
                width: 140,
                height: 140,
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                'Update Available',
                style: boldText.copyWith(fontSize: 22.0),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'A new version of the app is available.\nPlease update to continue.',
                style: mediumText.copyWith(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              FullWidthButton(
                title: 'Update',
                color: blackColor,
                action: () {
                  launch(storeUrl);
                },
              ),
              SizedBox(
                height: offsetMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
