import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/common_widget.dart';

class DialogService {
  final BuildContext context;

  DialogService(this.context);

  Future<dynamic> showCustomModalBottomSheet({
    @required Widget titleWidget,
    @required Widget bodyWidget,
    bool scrollControl = false,
  }) async {
    return await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: scrollControl,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(offsetBase),
          topLeft: Radius.circular(offsetBase),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Container(
        height: scrollControl
            ? MediaQuery.of(context).size.height - kToolbarHeight
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: offsetSm,
            ),
            BottomSheetTopStrip(),
            titleWidget,
            DividerWidget(),
            bodyWidget,
            SizedBox(
              height: offsetMd,
            ),
          ],
        ),
      ),
      isDismissible: true,
    );
  }

  void showSnackbar(
    String content,
    GlobalKey<ScaffoldState> _scaffoldKey, {
    SnackBarType type = SnackBarType.SUCCESS,
    Function() dismiss,
    int microseconds = 1500,
  }) {
    var backgroundColor = Colors.white;
    switch (type) {
      case SnackBarType.SUCCESS:
        backgroundColor = primaryColor;
        break;
      case SnackBarType.WARING:
        backgroundColor = Colors.orangeAccent;
        break;
      case SnackBarType.INFO:
        backgroundColor = blueColor;
        break;
      case SnackBarType.ERROR:
        backgroundColor = Colors.red;
        break;
    }

    _scaffoldKey.currentState
        .showSnackBar(SnackBar(
          content: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(offsetBase)),
            elevation: 1.0,
            child: Container(
              padding: EdgeInsets.all(offsetBase),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                gradient: getGradientColor(color: backgroundColor),
              ),
              child: Text(
                content,
                style: semiBold.copyWith(fontSize: fontMd, color: Colors.white),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(microseconds: 1500),
        ))
        .closed
        .then((value) {
      if (dismiss != null) dismiss();
    });
  }

  Future<dynamic> showCustomDialog ({
    @required Widget titleWidget,
    @required Widget bodyWidget,
    @required Widget bottomWidget,
  }) async {
    return await showDialog<dynamic>(
        context: context,
        builder: (context) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              padding: EdgeInsets.all(offsetBase),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(offsetBase),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(offsetBase), topRight: Radius.circular(offsetBase)),
                        ),
                        child: titleWidget
                    ),
                    DividerWidget(),
                    bodyWidget,
                    DividerWidget(),
                    Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(offsetBase), bottomRight: Radius.circular(offsetBase)),
                        ),
                        child: bottomWidget
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

enum SnackBarType { SUCCESS, WARING, INFO, ERROR }
