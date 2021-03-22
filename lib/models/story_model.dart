import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/image_widget.dart';

class StoryModel {
  String id;
  String userid;
  String content;
  String thumbnail;
  String url;
  String regdate;
  String type;

  StoryModel({
    this.id,
    this.userid,
    this.content,
    this.thumbnail,
    this.url,
    this.regdate,
    this.type,
  });

  Widget addCell() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: offsetXSm, vertical: offsetXSm),
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
        child: Stack(
          children: [
            Image.network(
              currentUser.imgurl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, widget, event) {
                return event == null
                    ? widget
                    : Center(
                        child: Image.asset(
                          'assets/icons/ic_logo.png',
                          color: Colors.grey,
                          width: 48,
                          fit: BoxFit.fitWidth,
                        ),
                      );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(24.0))),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.all(offsetSm),
                child: Text(
                  'Add to\nStory',
                  style:
                      boldText.copyWith(fontSize: fontXSm, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userid': userid,
      'content': content,
      'thumbnail': thumbnail,
      'url': url,
      'regdate': regdate,
      'type': type,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'],
      userid: map['userid'],
      regdate: map['regdate'],
      content: map['content'],
      thumbnail: map['thumbnail'],
      url: map['url'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) =>
      StoryModel.fromMap(json.decode(source));
}

class ExtraStoryModel {
  UserModel user;
  List<dynamic> list;

  ExtraStoryModel({this.user, this.list});

  factory ExtraStoryModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> stories = [];
    stories = (map['list'].map((item) => StoryModel.fromMap(item)).toList());

    var rArray = [];
    for (var story in stories) {
      if (story.type != null) {
        rArray.add(story);
      }
    }
    rArray.sort((b, a) => b.regdate.compareTo(a.regdate));

    return new ExtraStoryModel(
      user: UserModel.fromMap(map['user']),
      list: rArray,
    );
  }

  Widget cell({
    Widget content,
    Function() action,
  }) {
    return InkWell(
      onTap: () {
        action();
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: offsetXSm, vertical: offsetXSm),
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
          child: Stack(
            children: [
              content == null
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: getGradientColor(color: getRandomColor()),
                      ),
                    )
                  : content,
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(24.0))),
                    child: CircleAvatarWidget(
                      headurl: user.imgurl,
                      size: 40,
                      borderWidth: 0.5,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.all(offsetSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringService.getCurrentTimeValue(list.last.regdate),
                        maxLines: 1,
                        style: mediumText.copyWith(
                            fontSize: fontXSm, color: Colors.white),
                      ),
                      Text(
                        user.id == currentUser.id ? 'Yours' : user.username,
                        maxLines: 1,
                        style: boldText.copyWith(
                            fontSize: fontXSm, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
