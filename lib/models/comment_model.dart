import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/models/review_model.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class CommentModel {
  String id;
  String postid;
  String userid;
  String commentid;
  String content;
  String regdate;
  String other;

  CommentModel({
    this.id,
    this.postid,
    this.userid,
    this.commentid,
    this.content,
    this.regdate,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return {
      'postid': postid,
      'userid': userid,
      'commentid': commentid,
      'content': content,
      'regdate': regdate,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postid: map['postid'],
      userid: map['userid'],
      commentid: map['commentid'],
      content: map['content'],
      regdate: map['regdate'],
      other: map['other'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  Future<Map<String, dynamic>> add(BuildContext context) async {
    var param = toMap();
    var resp = await NetworkService(context)
        .ajax('chat_add_comment', param, isProgress: true);
    return resp;
  }
}

class ExtraCommentModel {
  CommentModel comment;
  UserModel user;
  List<ReviewModel> reviews;

  ExtraCommentModel({this.comment, this.user, this.reviews});

  factory ExtraCommentModel.fromMap(Map<String, dynamic> map) {
    List<ReviewModel> reviews = [];
    if (map['reviews'] != null) {
      for (var json in map['reviews']) {
        ReviewModel model = ReviewModel.fromMap(json);
        reviews.add(model);
      }
    }

    return new ExtraCommentModel(
      comment: CommentModel.fromMap(map['comment']),
      user: UserModel.fromMap(map['user']),
      reviews: reviews,
    );
  }

  Widget getWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatarWidget(headurl: user.imgurl, size: 36.0,),
          SizedBox(width: offsetSm,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetSm),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
                  boxShadow: [containerShadow()]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, style: boldText.copyWith(fontSize: fontBase),),
                  SizedBox(height: offsetSm,),
                  Text(comment.content, style: mediumText.copyWith(fontSize: fontSm),),
                  SizedBox(height: offsetBase,),
                  Row(
                    children: [
                      Text(
                        StringService.getCurrentTimeValue(comment.regdate),
                        style: mediumText.copyWith(fontSize: fontSm),
                      ),
                      SizedBox(width: offsetLg,),
                      ReviewGroupWidget(reviews: reviews),
                      if (appSettingInfo['isReplyComment']) Row(
                        children: [
                          SizedBox(width: offsetLg,),
                          CircleIconWidget(
                            size: 18,
                            padding: 4,
                            icon: Icon(Icons.comment_outlined, size: 10, color: Colors.green,),
                          ),
                          SizedBox(width: offsetSm,),
                          Text('1.3 K', style: mediumText.copyWith(fontSize: fontSm),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}