import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class FullWidthButton extends FlatButton {
  FullWidthButton({
    Key key,
    String title,
    Widget customTitleWidget,
    Color color = primaryColor,
    void Function() action,
    Color textColor = Colors.white,
    double buttonRadius = 12.0,
    double height = 44.0,
  }) : super(
          key: key,
          child: Container(
            height: height,
            alignment: Alignment.center,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: customTitleWidget == null
                ? Text(
                    title,
                    textAlign: TextAlign.center,
                    style: semiBold.copyWith(
                        color: textColor ?? Colors.white, fontSize: fontLg),
                  )
                : customTitleWidget,
          ),
          onPressed: action,
          color: color,
          disabledColor: color.withOpacity(0.5),
          textColor: textColor,
          disabledTextColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        );
}
