import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/models/review_model.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';

class ReviewScreen extends StatefulWidget {
  final String postid;

  const ReviewScreen({
    Key key,
    @required this.postid
  }) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<ExtraReviewModel> reviews = [];
  List<ExtraReviewModel> showData = [];

  var selectIndex = 0;

  List<PopupMenuItem> menuItems = [];
  var selectedItems = [];

  var menuTitles = [
    'Likes', 'Funny', 'Love', 'Angry', 'Sad', 'Wow'
  ];

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getData();
    });

    menuItems.add(PopupMenuItem(
        child: InkWell(
          onTap: () {
            selectIndex = 0;
            Navigator.of(context).pop();
            filter();
          },
          child: Container(
            width: 100.0,
            child: Row(
              children: [
                Text('All', style: semiBold.copyWith(fontSize: fontMd),),
              ],
            ),
          ),
        )
    ),);

    selectedItems.add(Container(
      width: 100.0,
      child: Row(
        children: [
          Text('All', style: semiBold.copyWith(fontSize: fontMd),),
        ],
      ),
    ));

    for (var title in menuTitles) {
      menuItems.add(PopupMenuItem(
          child: InkWell(
            onTap: () {
              selectIndex = menuTitles.indexOf(title) + 1;
              Navigator.of(context).pop();
              filter();
            },
            child: Container(
              width: 100.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 75.0,
                      child: Text(title, style: semiBold.copyWith(fontSize: fontMd),)
                  ),
                  Image.asset(reviewIcons[menuTitles.indexOf(title)], width: 24.0, height: 24.0,),
                ],
              ),
            ),
          )
      ),);
      selectedItems.add(Container(
        width: 100.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 75.0,
                child: Text(title, style: semiBold.copyWith(fontSize: fontMd),)
            ),
            Image.asset(reviewIcons[menuTitles.indexOf(title)], width: 24.0, height: 24.0,),
          ],
        ),
      ));
    }
  }

  void _getData() async {
    var param = {
      'postid' : widget.postid,
    };
    var resp = await NetworkService(context)
        .ajax('chat_review', param, isProgress: true);
    if (resp['ret'] == 10000) {
      reviews.clear();
      for (var json in resp['result']) {
        ExtraReviewModel model = ExtraReviewModel.fromMap(json);
        reviews.add(model);
      }
      reviews.sort((b, a) => a.review.regdate.compareTo(b.review.regdate));

      filter();
    }
  }

  void filter() {
    showData.clear();
    if (selectIndex == 0) {
      showData.addAll(reviews);
    } else {
      for (var review in reviews) {
        if (review.review.type == '${selectIndex - 1}') {
          showData.add(review);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Reviews (${reviews.length})',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase, ),
        child: Column(
          children: [
            SizedBox(height: offsetMd,),
            InkWell(
              onTap: () {
                DialogService(context).showPopupMenu(Offset(0, offsetXLg * 2), items: menuItems);
              },
              child: Row(
                children: [
                  selectedItems[selectIndex],
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            SizedBox(height: offsetBase,),
            Expanded(
              child: showData.isEmpty
                  ? EmptyWidget(
                title: 'The review data is empty.',
              ) : ListView.builder(
                shrinkWrap: true,
                itemCount: showData.length,
                itemBuilder: (context, i) {
                  return showData[i].itemWidget();
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
