import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/models/review_model.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String headurl;
  final double size;
  final double borderWidth;

  const CircleAvatarWidget({
    Key key,
    @required this.headurl,
    this.size = 120,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size)),
          border: Border.all(color: Colors.white, width: borderWidth)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          headurl.isEmpty ? avatarUrl : headurl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, widget, event) {
            return event == null
                ? widget
                : Center(
                    child: Image.asset(
                      'assets/icons/ic_logo.png',
                      color: Colors.grey,
                      width: size / 2,
                      fit: BoxFit.fitWidth,
                    ),
                  );
          },
          errorBuilder: (context, url, error) => Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: size,
          ),
        ),
      ),
    );
  }
}

class CircleIconWidget extends StatelessWidget {
  final double size;
  final double borderWidth;
  final double padding;
  final Color color;
  final Widget icon;

  const CircleIconWidget({
    Key key,
    this.size = 44.0,
    this.borderWidth = 0.3,
    this.padding = offsetSm,
    this.color = primaryColor,
    @required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        border: Border.all(color: color, width: borderWidth),
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      ),
      child: icon,
    );
  }
}

class ReviewGroupWidget extends StatelessWidget {
  final List<ReviewModel> reviews;
  final Function() toLike;
  final Color titleColor;

  const ReviewGroupWidget({
    Key key,
    @required this.reviews,
    this.toLike,
    this.titleColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> reviewTypes = ['0'];
    List<String> icons = [reviewIcons[0]];
    if (reviews != null) {
      reviewTypes.clear();
      icons.clear();
      for (var review in reviews) {
        if (!reviewTypes.contains(review.type)) {
          reviewTypes.add(review.type);
        }
      }
      if (reviewTypes.isEmpty) {
        reviewTypes.add('0');
        icons.add(reviewIcons[0]);
      }
      for (var type in reviewTypes) {
        icons.add(reviewIcons[int.parse(type)]);
      }
    }

    return InkWell(
      onTap: () {
        if (toLike != null) toLike();
      },
      child: Row(
        children: [
          Stack(
            children: [
              for (var iconName in icons)
                Container(
                    margin: EdgeInsets.only(
                        left: 15 *
                            double.parse(
                                '${icons.indexOf(iconName)}')),
                    child: Image.asset(
                      iconName,
                      width: 24.0,
                    )),
            ],
          ),
          SizedBox(
            width: offsetSm,
          ),
          Text(
            StringService.getCountValue(reviews.length),
            style: mediumText.copyWith(fontSize: fontBase, color: titleColor),
          ),
        ],
      ),
    );
  }

}