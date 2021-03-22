import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simplechat/models/media_model.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/image_service.dart';
import 'package:simplechat/services/load_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/string_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:video_player/video_player.dart';

class AddStoryScreen extends StatefulWidget {
  @override
  _AddStoryScreenState createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PickedFile _image, _video;
  VideoPlayerController _videoController;
  Uint8List thumbnail;

  var _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _playVideo() async {
    if (_video != null && mounted) {
      _videoController = VideoPlayerController.file(File(_video.path));
      await _videoController.initialize();
      await _videoController.setLooping(true);
      await _videoController.play();
      setState(() {});
    }
  }

  _imgPicker(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
        source: source, imageQuality: 50, maxWidth: 1000, maxHeight: 1000);

    setState(() {
      _image = image;
    });
  }

  _videoPicker(ImageSource source) async {
    PickedFile video = await ImagePicker().getVideo(
      source: source,
    );
    setState(() {
      _video = video;
      _playVideo();
    });
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
          titleString: 'Add Story',
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: offsetBase),
                  child: Text(
                    'Add Media',
                    style: semiBold.copyWith(fontSize: fontMd),
                  ),
                ),
                SizedBox(
                  height: offsetBase,
                ),
                (_image == null && _video == null)
                    ? DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(offsetBase),
                        dashPattern: [8, 4],
                        strokeWidth: 2,
                        color: Colors.blueGrey,
                        child: Container(
                          width: double.infinity,
                          height: (MediaQuery.of(context).size.width -
                                  offsetBase * 2) *
                              0.56,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(offsetBase)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(offsetBase)),
                            child: Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    showPickerDialog();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: offsetLg),
                                    padding: EdgeInsets.all(offsetMd),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(offsetMd)),
                                        gradient: getGradientColor(
                                            color: Colors.purple)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Spacer(),
                                        SvgPicture.asset(
                                          'assets/icons/ic_picture.svg',
                                          width: 48,
                                          height: 48,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: offsetBase,
                                        ),
                                        Text(
                                          'Image',
                                          style: semiBold.copyWith(
                                            fontSize: fontLg,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                if (appSettingInfo['isVideoStory'])
                                  SizedBox(
                                    width: offsetXLg,
                                  ),
                                if (appSettingInfo['isVideoStory'])
                                  InkWell(
                                    onTap: () {
                                      showPickerDialog(isVideo: true);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: offsetLg),
                                      padding: EdgeInsets.all(offsetMd),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(offsetMd)),
                                          gradient: getGradientColor(
                                              color: Colors.pink)),
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          SvgPicture.asset(
                                            'assets/icons/ic_camera.svg',
                                            width: 48,
                                            height: 48,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: offsetBase,
                                          ),
                                          Text(
                                            'Video',
                                            style: semiBold.copyWith(
                                              fontSize: fontLg,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(offsetBase))),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(offsetBase)),
                              child: _image != null
                                  ? previewImage()
                                  : previewVideo(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _image = null;
                                      _video = null;
                                      if (_videoController != null &&
                                          _videoController.value.isPlaying) {
                                        _videoController.pause();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18.0))),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                if (thumbnail != null) Image.memory(thumbnail),
                SizedBox(
                  height: offsetLg,
                ),
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
                FullWidthButton(
                  title: 'Add Story',
                  action: () {
                    _addStory();
                  },
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

  Future<void> _addStory() async {
    String comment = _commentController.text;
    if (_image == null && _video == null && comment.isEmpty) {
      DialogService(context).showSnackbar(
          'Please input a story data.', _scaffoldKey,
          type: SnackBarType.WARING);
      return;
    }

    LoadService().showLoading(context);

    var param = {
      'userid': currentUser.id,
      'regdate': StringService.getCurrentUTCTime(),
    };
    var resp = await NetworkService(context)
        .ajax('chat_add_story', param, isProgress: false);

    var respUpload;
    var storyid = '${resp['result']}';
    if (_image == null && _video == null) {
      MediaModel mediaModel = MediaModel(
        userid: currentUser.id,
        mediaid: storyid,
        content: comment,
        kind: 'STORY',
        type: 'TEXT',
        regdate: StringService.getCurrentUTCTime(),
      );
      respUpload = await mediaModel.upload();
    } else {
      String base64Thumnbail;
      File file;
      String type;
      if (_image != null) {
        base64Thumnbail = await ImageService().getThumbnailBase64FromImage(
            File(_image.path),
            width: 90,
            height: 160);
        file = File(_image.path);
        type = 'IMAGE';
      } else if (_video != null) {
        base64Thumnbail = await ImageService().getThumbnailBase64FromVideo(
            File(_video.path),
            width: 90,
            height: 160);
        file = File(_video.path);
        type = 'VIDEO';
      }

      MediaModel mediaModel = MediaModel(
        userid: currentUser.id,
        mediaid: storyid,
        content: comment,
        kind: 'STORY',
        type: type,
        regdate: StringService.getCurrentUTCTime(),
      );
      respUpload =
          await mediaModel.upload(file: file, thumbnail: base64Thumnbail);
    }

    LoadService().hideLoading(context);

    if (respUpload['ret'] == 10000) {
      DialogService(context).showSnackbar(
          'Successfully posting your story.', _scaffoldKey, dismiss: () {
        Navigator.of(context).pop(true);
      });
    }
  }

  Widget previewVideo() {
    return Container(
      alignment: Alignment.center,
      height: (MediaQuery.of(context).size.width - offsetBase * 2) * 0.56,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
      ),
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      ),
    );
  }

  Widget previewImage() {
    return Image.file(
      File(_image.path),
      width: MediaQuery.of(context).size.width - offsetBase * 2,
      height: (MediaQuery.of(context).size.width - offsetBase * 2) * 0.56,
      fit: BoxFit.cover,
    );
  }

  void showPickerDialog({bool isVideo = false}) {
    var pickers = [
      {
        'icon': Icons.image,
        'title': 'From Gallery',
        'source': ImageSource.gallery,
        'color': primaryColor
      },
      {
        'icon': Icons.videocam,
        'title': 'From Camera',
        'source': ImageSource.camera,
        'color': blueColor
      },
    ];
    DialogService(context).showCustomModalBottomSheet(
      titleWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: boldText.copyWith(fontSize: fontBase, color: Colors.red),
              ),
            ),
            Text(
              'Choose Media',
              style: boldText.copyWith(fontSize: fontLg),
            ),
            Text(
              'Cancel',
              style: boldText.copyWith(fontSize: fontBase, color: Colors.white),
            ),
          ],
        ),
      ),
      bodyWidget: Container(
        padding: EdgeInsets.all(offsetBase),
        child: Column(
          children: [
            Text(
              'Please choose the image picker source.',
              style: mediumText.copyWith(fontSize: fontMd),
            ),
            SizedBox(
              height: offsetMd,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: offsetLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var data in pickers)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (isVideo) {
                          _videoPicker(data['source']);
                        } else {
                          _imgPicker(data['source']);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: offsetBase, vertical: offsetBase),
                        decoration: BoxDecoration(
                          gradient: getGradientColor(color: data['color']),
                          borderRadius:
                              BorderRadius.all(Radius.circular(offsetBase)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              data['icon'],
                              size: 36,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: offsetSm,
                            ),
                            Text(
                              data['title'],
                              style: semiBold.copyWith(
                                  fontSize: fontBase, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
