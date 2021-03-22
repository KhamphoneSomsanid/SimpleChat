import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  VideoPlayerController _videoController;
  var _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    if (_videoController != null) {
      _videoController.dispose();
    }
    if (_commentController != null) {
      _commentController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MainBarWidget(
          titleString: 'Add Post',
          actions: [
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: offsetBase),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Comment',
                        style: semiBold.copyWith(fontSize: fontMd),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _commentController.text = '';
                          });
                        },
                        child: Text(
                          'Clear',
                          style: semiBold.copyWith(
                            fontSize: fontMd,
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: offsetBase,
                ),
                Container(
                  padding: EdgeInsets.all(offsetBase),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 1,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _commentController,
                    minLines: 5,
                    maxLines: 7,
                    keyboardType: TextInputType.multiline,
                    style: mediumText.copyWith(fontSize: fontBase),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Add Story Comment',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: offsetLg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
