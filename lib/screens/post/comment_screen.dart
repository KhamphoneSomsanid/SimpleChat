import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/models/comment_model.dart';
import 'package:simplechat/models/post_model.dart';
import 'package:simplechat/screens/post/review_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/image_widget.dart';

class CommentScreen extends StatefulWidget {
  final ExtraPostModel model;

  const CommentScreen({
    Key key,
    @required this.model
  }) : super(key: key);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ExtraCommentModel> comments = [];
  var msgController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getData();
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  void _getData() async {
    var param = {
      'postid' : widget.model.post.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_comment', param, isProgress: true);
    if (resp['ret'] == 10000) {
      comments.clear();
      for (var item in resp['result']) {
        ExtraCommentModel model = ExtraCommentModel.fromMap(item);
        comments.add(model);
      }
      comments.sort((b, a) => a.comment.regdate.compareTo(b.comment.regdate));
      setState(() {});
    }
  }

  Widget headerWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetSm),
      padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
        gradient: getGradientColor(),
      ),
      child: Row(
        children: [
          ReviewGroupWidget(
            reviews: widget.model.reviews,
            titleColor: Colors.white,
            toLike: () {
              NavigatorService(context).pushToWidget(screen: ReviewScreen(postid: widget.model.post.id));
            },
          ),
          Spacer(),
          Icon(Icons.arrow_right, color: Colors.green,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MainBarWidget(
          titleString: 'Comment (${comments.length})',
        ),
        body: SafeArea(
          child: Column(
            children: [
              headerWidget(),
              comments.isEmpty
                  ? Expanded(
                    child: EmptyWidget(
                title: 'The comment data is not existed yet. After some delay, Please try it again.',
              ),
                  ) : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    return comments[i].getWidget(
                      setLike: (offset) {
                        DialogService(context).showLikePopupMenu(
                          offset,
                          setLike: (index) async {
                            Navigator.of(context).pop();
                            var isUpdate = await comments[i].setLike(context, _scaffoldKey, index);
                            if (isUpdate) _getData();
                          }
                        );
                      }
                    );
                  }
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: offsetMd),
                width: double.infinity,
                height: 56,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: offsetSm),
                            padding: EdgeInsets.symmetric(horizontal: offsetSm),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: TextField(
                              controller: msgController,
                              autofocus: true,
                              style: mediumText.copyWith(fontSize: fontMd),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Comment ...',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: offsetBase,),
                    InkWell(
                      onTap: () {
                        _add();
                      },
                      child: CircleIconWidget(
                        size: 28,
                        padding: 6.0,
                        icon: Icon(Icons.send, color: Colors.green, size: 16,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _add() async {
    String msg = msgController.text;
    if (msg.isEmpty) {
      DialogService(context).showSnackbar('The comment is empty. Please input some msg.', _scaffoldKey, type: SnackBarType.ERROR);
      return;
    }

    CommentModel commentModel = CommentModel(
      postid: '${widget.model.post.id}',
      userid: '${currentUser.id}',
      commentid: '',
      content: msg,
      regdate: StringService.getCurrentUTCTime(),
    );

    var resp = await commentModel.add(context);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar('Successful adding comment.', _scaffoldKey);
      msgController.text = '';
      _getData();
    }
  }

}
