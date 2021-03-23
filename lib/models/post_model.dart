import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/image_widget.dart';

class PostModel {
  String id;
  String userid;
  String content;
  String regdate;
  String tag;
  String other;

  PostModel({
    this.id,
    this.userid,
    this.content,
    this.regdate,
    this.tag,
    this.other,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return new PostModel(
      id: map['id'] as String,
      userid: map['userid'] as String,
      content: map['content'] as String,
      regdate: map['regdate'] as String,
      tag: map['tag'] as String,
      other: map['other'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': this.userid,
      'content': this.content,
      'regdate': this.regdate,
      'tag': this.tag,
      'other': this.other,
    };
  }

  upload() async {
    var param = toMap();
    var resp = await NetworkService(null)
        .ajax('chat_add_post', param, isProgress: false);
    return resp;
  }
}

class ExtraPostModel {
  UserModel user;
  PostModel post;
  List<MediaModel> list;

  ExtraPostModel({this.post, this.list, this.user});

  factory ExtraPostModel.fromMap(Map<String, dynamic> map) {
    List<MediaModel> medias = [];
    for (var json in map['list']) {
      MediaModel model = MediaModel.fromMap(json);
      medias.add(model);
    }

    return new ExtraPostModel(
      user: UserModel.fromMap(map['user']),
      post: PostModel.fromMap(map['post']),
      list: medias,
    );
  }

  Map<String, dynamic> toMap() {
    List<dynamic> listMap = [];
    for (var item in list) {
      listMap.add(item.toMap());
    }
    return {
      'user': user.toMap(),
      'post': post.toMap(),
      'list': listMap,
    };
  }

  String toJson() => json.encode(toMap());

  Widget item({
    Function() toUserDtail,
    Function() toDtail,
    Function() toLike,
    Function() toComment,
    Function() toFollow,
    Function() setLike,
    Function() setComment,
    Function() setFollow,
  }) {
    List<String> tags = post.tag.split(',');
    return InkWell(
      onTap: () {
        toDtail();
      },
      child: Container(
        margin: EdgeInsets.only(top: offsetSm),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: offsetSm, horizontal: offsetBase),
              child: InkWell(
                onTap: () {
                  toUserDtail();
                },
                child: Row(
                  children: [
                    CircleAvatarWidget(
                      headurl: user.imgurl,
                      size: 44,
                    ),
                    SizedBox(
                      width: offsetBase,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: semiBold.copyWith(fontSize: fontBase),
                          ),
                          SizedBox(
                            height: offsetXSm,
                          ),
                          Text(
                            StringService.getCurrentTimeValue(post.regdate),
                            style: mediumText.copyWith(
                                fontSize: fontSm, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            DividerWidget(
              padding: EdgeInsets.symmetric(vertical: offsetSm),
              thickness: 0.3,
            ),
            if (post.content.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: offsetSm, horizontal: offsetBase),
                child: Text(
                  post.content,
                  style: mediumText.copyWith(fontSize: fontBase),
                ),
              ),
            if (post.tag.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: offsetSm, horizontal: offsetBase),
                child: Wrap(
                  children: [
                    for (var stag in tags)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: offsetSm, vertical: 2),
                        decoration: BoxDecoration(
                            color: blueColor.withOpacity(0.5),
                            border: Border.all(color: blueColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(offsetBase))),
                        child: Text(
                          stag,
                          style: mediumText.copyWith(
                              fontSize: fontBase, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            Container(
              child: list.length == 1
                  ? list[0].cellMediaWidget(isOne: true)
                  : list.length == 2
                      ? Row(
                          children: [
                            Expanded(
                              child: list[0].cellMediaWidget(type: 4),
                            ),
                            SizedBox(
                              width: 1.0,
                            ),
                            Expanded(
                              child: list[1].cellMediaWidget(type: 5),
                            ),
                          ],
                        )
                      : list.length == 3
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: list[0].cellMediaWidget(type: 0),
                                    ),
                                    SizedBox(
                                      width: 1.0,
                                    ),
                                    Expanded(
                                      child: list[1].cellMediaWidget(type: 1),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: list[2].cellMediaWidget(type: 2),
                                    ),
                                    SizedBox(
                                      width: 1.0,
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                              ],
                            )
                          : list.length == 4
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              list[0].cellMediaWidget(type: 0),
                                        ),
                                        SizedBox(
                                          width: 1.0,
                                        ),
                                        Expanded(
                                          child:
                                              list[1].cellMediaWidget(type: 1),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              list[2].cellMediaWidget(type: 2),
                                        ),
                                        SizedBox(
                                          width: 1.0,
                                        ),
                                        Expanded(
                                          child:
                                              list[3].cellMediaWidget(type: 3),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              list[0].cellMediaWidget(type: 0),
                                        ),
                                        SizedBox(
                                          width: 1.0,
                                        ),
                                        Expanded(
                                          child:
                                              list[1].cellMediaWidget(type: 1),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              list[2].cellMediaWidget(type: 2),
                                        ),
                                        SizedBox(
                                          width: 1.0,
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              list[3].cellMediaWidget(type: 3),
                                              AspectRatio(
                                                aspectRatio: 1.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      offsetBase))),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'See More',
                                                          style:
                                                              boldText.copyWith(
                                                                  fontSize:
                                                                      fontLg,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        Text(
                                                          '+ ${list.length - 4}',
                                                          style:
                                                              boldText.copyWith(
                                                                  fontSize:
                                                                      fontLg,
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: offsetBase, vertical: offsetBase),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      toLike();
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            for (var iconName in reviewIcons)
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 15 *
                                          double.parse(
                                              '${reviewIcons.indexOf(iconName)}')),
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
                          '1.3 K',
                          style: mediumText.copyWith(fontSize: fontBase),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      toComment();
                    },
                    child: Row(
                      children: [
                        CircleIconWidget(
                            size: 28.0,
                            padding: offsetSm,
                            icon: SvgPicture.asset(
                              'assets/icons/ic_chat.svg',
                              width: 12,
                              color: Colors.green,
                            )),
                        SizedBox(
                          width: offsetSm,
                        ),
                        Text(
                          '1.3 K',
                          style: mediumText.copyWith(fontSize: fontBase),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: offsetBase,
                  ),
                  InkWell(
                    onTap: () {
                      toFollow();
                    },
                    child: Row(
                      children: [
                        CircleIconWidget(
                            size: 28.0,
                            padding: offsetSm,
                            icon: SvgPicture.asset(
                              'assets/icons/ic_follow.svg',
                              width: 12,
                              color: Colors.green,
                            )),
                        SizedBox(
                          width: offsetSm,
                        ),
                        Text(
                          '1.3 K',
                          style: mediumText.copyWith(fontSize: fontBase),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            DividerWidget(),
            Container(
              padding: EdgeInsets.all(offsetBase),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          setLike();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleIconWidget(
                              size: 28.0,
                              padding: offsetSm,
                              icon: SvgPicture.asset(
                                'assets/icons/ic_like.svg',
                                width: 12.0,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: offsetSm,
                            ),
                            Text(
                              'Likes',
                              style: mediumText.copyWith(fontSize: fontBase),
                            )
                          ],
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          setComment();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleIconWidget(
                              size: 28.0,
                              padding: offsetSm,
                              icon: Icon(
                                Icons.comment_outlined,
                                size: 12,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: offsetSm,
                            ),
                            Text(
                              'Comments',
                              style: mediumText.copyWith(fontSize: fontBase),
                            )
                          ],
                        ),
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          setFollow();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleIconWidget(
                              size: 28.0,
                              padding: offsetSm,
                              icon: Icon(
                                Icons.share,
                                size: 12,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: offsetSm,
                            ),
                            Text(
                              'Follow',
                              style: mediumText.copyWith(fontSize: fontBase),
                            )
                          ],
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
