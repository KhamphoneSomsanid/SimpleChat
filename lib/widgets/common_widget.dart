import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class DividerWidget extends Padding {
  DividerWidget({
    Key key,
    Color color = Colors.grey,
    double thickness = 0.5,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  }) : super(
          padding: padding,
          child: Divider(
            key: key,
            color: color,
            thickness: thickness,
            height: 0,
          ),
        );
}

class BottomSheetTopStrip extends Container {
  BottomSheetTopStrip()
      : super(
          width: 75.0,
          height: 5.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
}

class SettingCellWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String detail;
  final Color textColor;

  const SettingCellWidget(
      {Key key,
      this.icon,
      this.title,
      this.detail,
      this.textColor = primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
          gradient: getGradientColor(color: textColor),
        ),
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              child: SvgPicture.asset(
                icon,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: offsetBase,
            ),
            Text(
              title,
              style: semiBold.copyWith(fontSize: fontBase, color: Colors.white),
            ),
            Spacer(),
            Text(
              detail,
              style: mediumText.copyWith(fontSize: fontSm, color: textColor),
            ),
            Icon(
              Icons.arrow_right_outlined,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
