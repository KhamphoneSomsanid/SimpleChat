import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:simplechat/utils/colors.dart';

class SplashScreen extends StatelessWidget {
  final Widget homeWidget;
  const SplashScreen({Key key, this.homeWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            child: CustomSplash(
              imagePath: 'assets/images/logo.png',
              home: homeWidget,
              duration: 3000,
              type: CustomSplashType.StaticDuration,
              backGroundColor: primaryColor,
              logoSize: 70,
            ),
          )
        ],
      ),
    );
  }
}
