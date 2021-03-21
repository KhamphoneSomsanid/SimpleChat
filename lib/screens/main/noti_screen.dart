import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';

class NotiScreen extends StatefulWidget {
  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleIcon: Container(
          padding: EdgeInsets.all(offsetBase),
          child: SvgPicture.asset(
            'assets/icons/ic_notification_on.svg',
            color: primaryColor,
          ),
        ),
        titleString: 'Notifications',
      ),
    );
  }
}
