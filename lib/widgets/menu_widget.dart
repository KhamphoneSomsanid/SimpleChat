import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    Key key,
    @required this.body,
    this.isMenu = false,
    this.during = 1000,
    this.isRight = true,
    this.padding = const EdgeInsets.all(offsetBase),
  }) : super(key: key);

  final Widget body;
  final bool isMenu;
  final int during;
  final bool isRight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: Duration(milliseconds: during),
      curve: Curves.fastOutSlowIn,
      alignment: Alignment.centerLeft,
      transform: Matrix4.translationValues(
          isMenu
              ? (isRight ? width * 0.2 : 0)
              : (isRight ? width : width * 0.8),
          0,
          0),
      child: Container(
        width: width * 0.8,
        height: height * 0.75,
        padding: padding,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [containerShadow(offsetX: -1.0, offsetY: 0.0)],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isRight ? offsetBase : 0),
              bottomLeft: Radius.circular(isRight ? offsetBase : 0),
              topRight: Radius.circular(isRight ? 0 : offsetBase),
              bottomRight: Radius.circular(isRight ? 0 : offsetBase),
            )),
        child: body,
      ),
    );
  }
}
