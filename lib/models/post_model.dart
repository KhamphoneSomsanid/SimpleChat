import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/models/comment_model.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/models/post_follow_model.dart';
import 'package:simplechat/models/review_model.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
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
  List<ReviewModel> reviews;
  List<PostFollowModel> follows;
  List<CommentModel> comments;

  ExtraPostModel(
      {this.post,
      this.list,
      this.user,
      this.reviews,
      this.follows,
      this.comments});

  factory ExtraPostModel.fromMap(Map<String, dynamic> map) {
    List<MediaModel> medias = [];
    if (map['list'] != null) {
      for (var json in map['list']) {
        MediaModel model = MediaModel.fromMap(json);
        medias.add(model);
      }
    }

    List<ReviewModel> reviews = [];
    if (map['review'] != null) {
      for (var json in map['review']) {
        ReviewModel model = ReviewModel.fromMap(json);
        reviews.add(model);
      }
    }

    List<PostFollowModel> follows = [];
    if (map['follow'] != null) {
      for (var json in map['follow']) {
        PostFollowModel model = PostFollowModel.fromMap(json);
        follows.add(model);
      }
    }

    List<CommentModel> comments = [];
    if (map['comment'] != null) {
      for (var json in map['comment']) {
        CommentModel model = CommentModel.fromMap(json);
        comments.add(model);
      }
    }

    return new ExtraPostModel(
      user: UserModel.fromMap(map['user']),
      post: PostModel.fromMap(map['post']),
      list: medias,
      reviews: reviews,
      follows: follows,
      comments: comments,
    );
  }

  Map<String, dynamic> toMap() {
    List<dynamic> listMap = [];
    for (var item in list) {
      listMap.add(item.toMap());
    }

    List<dynamic> reviewMap = [];
    for (var item in reviews) {
      reviewMap.add(item.toMap());
    }

    List<dynamic> followMap = [];
    for (var item in follows) {
      followMap.add(item.toMap());
    }

    List<dynamic> commentMap = [];
    for (var item in comments) {
      commentMap.add(item.toMap());
    }

    return {
      'user': user.toMap(),
      'post': post.toMap(),
      'list': listMap,
      'review': reviewMap,
      'follow': followMap,
      'comment': commentMap,
    };
  }

  String toJson() => json.encode(toMap());

  Widget item({
    Function() toUserDtail,
    Function() toDtail,
    Function() toLike,
    Function() toComment,
    Function() toFollow,
    Function(Offset) setLike,
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
                          ? Row(
                              children: [
                                Expanded(
                                  child: list[0].cellMediaWidget(type: 4),
                                ),
                                SizedBox(
                                  width: 1.0,
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      list[1].cellMediaWidget(type: 5),
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
                                                      offsetBase),
                                                  bottomLeft: Radius
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
                                                  '+ 1',
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
                              : list.length > 4? Column(
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
                                ) : Container(),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: offsetBase, vertical: offsetBase),
              child: Row(
                children: [
                  ReviewGroupWidget(
                    reviews: reviews,
                    toLike: toLike,
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
                          StringService.getCountValue(comments.length),
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
                          StringService.getCountValue(follows.length),
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
                      child: GestureDetector(
                        onTapDown: (details) {
                          setLike(details.globalPosition);
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

  setFollow(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {
    if (user.id == currentUser.id) {
      DialogService(context).showSnackbar(
          'This feed is yours. You can\'t follow it.', scaffoldKey,
          type: SnackBarType.WARING);
      return;
    }
    var param = {
      'userid': currentUser.id,
      'postid': post.id,
    };

    var resp = await NetworkService(context)
        .ajax('chat_add_follow_post', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], scaffoldKey);
    }
  }

  setLike(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
      int type) async {
    if (user.id == currentUser.id) {
      DialogService(context).showSnackbar(
          'This feed is yours. You can\'t follow it.', scaffoldKey,
          type: SnackBarType.WARING);
      return;
    }
    var param = {
      'userid': currentUser.id,
      'postid': post.id,
      'type': '$type',
    };

    var resp = await NetworkService(context)
        .ajax('chat_add_review_post', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], scaffoldKey);
    }
  }
}
