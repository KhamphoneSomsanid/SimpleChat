import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class ReviewModel {
  String id;
  String reviewid;
  String userid;
  String type;
  String kind;
  String regdate;
  String other;

  ReviewModel({
    this.id,
    this.reviewid,
    this.userid,
    this.type,
    this.kind,
    this.regdate,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewid': reviewid,
      'userid': userid,
      'type': type,
      'kind': kind,
      'regdate': regdate,
      'other': other,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      reviewid: map['reviewid'],
      userid: map['userid'],
      type: map['type'],
      kind: map['kind'],
      regdate: map['regdate'],
      other: map['other'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));
}

class ExtraReviewModel {
  UserModel user;
  ReviewModel review;

  ExtraReviewModel({this.user, this.review});

  factory ExtraReviewModel.fromMap(Map<String, dynamic> map) {
    return new ExtraReviewModel(
      user: UserModel.fromMap(map['user']),
      review: ReviewModel.fromMap(map['review']),
    );
  }

  Widget itemWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: offsetSm),
      padding: EdgeInsets.all(offsetBase),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
        boxShadow: [containerShadow(offsetX: 1, offsetY: 1)]
      ),
      child: Row(
        children: [
          CircleAvatarWidget(
            headurl: user.imgurl,
            size: 36.0,
          ),
          SizedBox(width: offsetBase,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.username, style: semiBold.copyWith(fontSize: fontMd),),
                SizedBox(height: offsetXSm,),
                Text(StringService.getCurrentTime(review.regdate),
                  style: mediumText.copyWith(fontSize: fontBase),
                ),
              ],
            ),
          ),
          Image.asset(reviewIcons[int.parse(review.type)], width: 24, height: 24,),
        ],
      ),
    );
  }

}
