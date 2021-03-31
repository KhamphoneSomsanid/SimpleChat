import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class OutLineLabel extends StatelessWidget {
  final String title;
  final Color titleColor;
  final double fontSize;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const OutLineLabel(
      {Key key,
      @required this.title,
      this.titleColor = primaryColor,
      this.fontSize = fontBase,
      this.margin = const EdgeInsets.only(left: offsetBase),
      this.padding = const EdgeInsets.symmetric(
          horizontal: offsetBase, vertical: offsetXSm)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: titleColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(fontSize)),
          border: Border.all(color: titleColor, width: 0.5)),
      margin: margin,
      padding: padding,
      child: Text(
        title,
        style: regularText.copyWith(fontSize: fontSize, color: titleColor),
      ),
    );
  }
}
