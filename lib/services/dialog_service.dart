import 'package:flutter/material.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/common_widget.dart';

class DialogService {
  final BuildContext context;

  DialogService(this.context);

  Future<dynamic> showCustomModalBottomSheet({
    Widget titleWidget,
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
            if (titleWidget != null) titleWidget,
            if (titleWidget != null) DividerWidget(),
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
    int milliseconds = 2000,
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
          duration: Duration(milliseconds: milliseconds),
        ))
        .closed
        .then((value) {
      if (dismiss != null) dismiss();
    });
  }

  Future<dynamic> showCustomDialog({
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
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(offsetBase),
                                  topRight: Radius.circular(offsetBase)),
                            ),
                            child: titleWidget),
                        DividerWidget(),
                        bodyWidget,
                        DividerWidget(),
                        Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(offsetBase),
                                  bottomRight: Radius.circular(offsetBase)),
                            ),
                            child: bottomWidget)
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Future<void> showLikePopupMenu(Offset offset, {Function(int) setLike}) async {
    double top = offset.dy;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(0, top - offsetBase, 0, 0),
        items: [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                for (var likeItem in reviewIcons)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (setLike != null) setLike(reviewIcons.indexOf(likeItem));
                        },
                        child: Image.asset(
                          likeItem,
                          width: 36,
                          height: 36,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ]);
  }

  Future<void> showPopupMenu(Offset offset, {List<PopupMenuItem> items}) async {
    double top = offset.dy;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(0, top - offsetBase, 0, 0),
        items: items,
    );
  }

  Future<void> showTypeDialog({
    Function() chooseImage,
    Function() chooseVideo,
    Function() chooseDocument,
    Function() chooseLocation,
    Function() chooseLink,
  }) {
    var types = [
      {
        'icon': Icons.image,
        'title': 'Image',
        'color': primaryColor,
        'action' : chooseImage,
      },
      {
        'icon': Icons.video_collection_sharp,
        'title': 'Video',
        'color': primaryColor,
        'action' : chooseVideo,
      },
      {
        'icon': Icons.book,
        'title': 'File',
        'color': primaryColor,
        'action' : chooseDocument,
      },
      {
        'icon': Icons.location_history,
        'title': 'Location',
        'color': primaryColor,
        'action' : chooseLocation,
      },
      {
        'icon': Icons.link,
        'title': 'Link',
        'color': primaryColor,
        'action' : chooseLink,
      },
    ];

    showCustomModalBottomSheet(
      bodyWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Column(
          children: [
            SizedBox(height: offsetSm,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                InkWell(
                  onTap: types[0]['action'],
                  child: getTypeWidget(types[0], (MediaQuery.of(context).size.width / 5 - offsetMd))
                ),
                InkWell(
                    onTap: types[1]['action'],
                    child: getTypeWidget(types[1], (MediaQuery.of(context).size.width / 5 - offsetMd))
                ),
                InkWell(
                    onTap: types[2]['action'],
                    child: getTypeWidget(types[2], (MediaQuery.of(context).size.width / 5 - offsetMd))
                ),
                InkWell(
                    onTap: types[3]['action'],
                    child: getTypeWidget(types[3], (MediaQuery.of(context).size.width / 5 - offsetMd))
                ),
                Container(),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Container(),
            //     InkWell(
            //         onTap: types[3]['action'],
            //         child: getTypeWidget(types[3], (MediaQuery.of(context).size.width / 5 - offsetMd))
            //     ),
            //     InkWell(
            //         onTap: types[4]['action'],
            //         child: getTypeWidget(types[4], (MediaQuery.of(context).size.width / 5 - offsetMd))
            //     ),
            //     Container(),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
  
  Widget getTypeWidget(dynamic type, double size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetSm),
      child: Column(
        children: [
          Container(
            width: size, height: size,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(size / 2)),
            ),
            child: Center(
              child: Icon(type['icon'], color: Colors.white, size: size / 2,),
            ),
          ),
          SizedBox(height: offsetSm,),
          Text(type['title'], style: semiBold.copyWith(fontSize: fontBase, color: type['color']),),
        ],
      ),
    );
  }

}

enum SnackBarType { SUCCESS, WARING, INFO, ERROR }
