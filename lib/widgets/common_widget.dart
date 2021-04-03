import 'package:flutter/cupertino.dart';
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
            if (detail != null)
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

class UpdateWidget extends StatelessWidget {
  const UpdateWidget({
    Key key,
    @required this.isUpdating,
    @required this.title,
  }) : super(key: key);

  final bool isUpdating;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isUpdating ? 48 : 0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: offsetSm),
        padding:
            EdgeInsets.symmetric(vertical: offsetSm, horizontal: offsetBase),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
          gradient: getGradientColor(color: blueColor),
        ),
        child: Text(
          title,
          style: semiBold.copyWith(fontSize: fontSm, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomSwitchWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool switchValue;
  final Function() action;

  const CustomSwitchWidget(
      {Key key,
      @required this.title,
      this.description,
      @required this.switchValue,
      @required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: semiBold.copyWith(fontSize: fontBase),
              ),
              if (description != null)
                SizedBox(
                  height: offsetSm,
                ),
              if (description != null)
                Text(
                  description,
                  style: mediumText.copyWith(fontSize: fontSm),
                ),
            ],
          ),
        ),
        SizedBox(
          width: offsetSm,
        ),
        CupertinoSwitch(
          value: switchValue,
          onChanged: (value) {
            action();
          },
        ),
      ],
    );
  }
}

Widget tagWidget(String tag, {bool isDelete = false, Function() delete}) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: offsetXSm, vertical: offsetXSm / 2),
    padding: EdgeInsets.symmetric(
        horizontal: offsetSm, vertical: offsetXSm),
    decoration: BoxDecoration(
        color: blueColor.withOpacity(0.5),
        border: Border.all(color: blueColor, width: 0.5),
        borderRadius:
        BorderRadius.all(Radius.circular(offsetBase))),
    child: isDelete? Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tag,
          style: mediumText.copyWith(
              fontSize: fontBase, color: Colors.white),
        ),
        SizedBox(
          width: offsetXSm,
        ),
        InkWell(
            onTap: delete,
            child: Icon(
              Icons.cancel,
              color: Colors.white,
              size: offsetBase,
            )),
      ],
    ) : Text(
      tag,
      style: mediumText.copyWith(
          fontSize: fontBase, color: Colors.white),
    ),
  );
}
