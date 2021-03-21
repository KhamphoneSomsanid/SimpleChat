import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';

class NearByScreen extends StatefulWidget {
  @override
  _NearByScreenState createState() => _NearByScreenState();
}

class _NearByScreenState extends State<NearByScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleIcon: Container(
          padding: EdgeInsets.all(offsetBase),
          child: SvgPicture.asset(
            'assets/icons/ic_nearby.svg',
            color: primaryColor,
          ),
        ),
        titleString: 'Nearby',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
      ),
    );
  }
}
