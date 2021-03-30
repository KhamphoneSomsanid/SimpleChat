import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class UserReviewCell extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final double iconSize;
  final double offsetSize;
  final Color color;

  const UserReviewCell({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.value,
    this.iconSize = 36.0,
    this.offsetSize = offsetSm,
    this.color = primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: offsetXSm),
        padding: EdgeInsets.symmetric(vertical: offsetBase),
        decoration: BoxDecoration(
          gradient: getGradientColor(color: color),
          borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              padding: EdgeInsets.all(offsetSize),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(iconSize / 2)),
              ),
              child: SvgPicture.asset(
                icon,
                color: color,
              ),
            ),
            SizedBox(
              height: offsetSm,
            ),
            Text(
              value,
              style: mediumText.copyWith(fontSize: fontSm, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
