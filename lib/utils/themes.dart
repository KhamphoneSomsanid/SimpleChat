import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';

const String fontFamily = 'Montserrat';

TextStyle blackText = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle extraBold = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle boldText = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle semiBold = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle mediumText = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle regularText = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle lightText = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w200,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle thinText = TextStyle(
    fontSize: fontBase,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w100,
    fontStyle: FontStyle.normal,
    color: blackColor);

TextStyle titleText = TextStyle(
    fontSize: fontBase,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: blackColor);

BoxShadow containerShadow({
  double offsetX = 2.0,
  double offsetY = 2.0,
  double blurRadius = 3.0,
  Color shadowColor = shadowColor,
}) {
  return BoxShadow(
    color: shadowColor,
    blurRadius: blurRadius,
    offset: Offset(offsetX, offsetY), // changes position of shadow
  );
}
