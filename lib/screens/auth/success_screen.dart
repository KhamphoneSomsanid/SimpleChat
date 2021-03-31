import 'package:flutter/material.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class SuccessScreen extends StatefulWidget {
  final Widget iconWidget;
  final String title;
  final String description;
  final Widget nextScreen;

  const SuccessScreen(
      {Key key,
      this.iconWidget,
      @required this.title,
      this.description,
      this.nextScreen})
      : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2500), () {
      _nextAction();
    });
  }

  void _nextAction() {
    if (widget.nextScreen == null) {
      Navigator.of(context).pop();
    } else {
      NavigatorService(context)
          .pushToWidget(screen: widget.nextScreen, replace: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                padding: EdgeInsets.all(120 / 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(120 / 2)),
                ),
                child: widget.iconWidget == null
                    ? Icon(
                        Icons.check,
                        color: primaryColor,
                        size: 120 / 2,
                      )
                    : widget.iconWidget,
              ),
              SizedBox(
                height: offsetLg,
              ),
              Text(
                widget.title,
                style: semiBold.copyWith(fontSize: fontLg, color: Colors.white),
              ),
              SizedBox(
                height: offsetBase,
              ),
              if (widget.description != null)
                Text(
                  widget.description,
                  style: semiBold.copyWith(
                      fontSize: fontBase, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
