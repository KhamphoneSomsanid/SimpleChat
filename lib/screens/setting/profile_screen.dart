import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simplechat/screens/setting/friend_list_screen.dart';
import 'package:simplechat/screens/setting/invite_screen.dart';
import 'package:simplechat/screens/setting/request_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/image_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/common_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var friendCount = '';
  var requestCount = '';
  var isRequestBadge = false;
  var isFriendBadge = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getRelate();
    });
  }

  _getRelate() async {
    isRequestBadge = await PreferenceService().getRequestBadge();
    isFriendBadge = await PreferenceService().getFriendBadge();

    var param = {
      'id': currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_user_releate', param, isProgress: true);
    if (resp['ret'] == 10000) {
      friendCount = '(${resp['result']['friend'] as int})';
      requestCount = '(${resp['result']['request'] as int})';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var aboutItems = [
      {
        'icon': Icon(Icons.account_box),
        'title': currentUser.username,
      },
      {
        'icon': Icon(Icons.email),
        'title': currentUser.email,
      },
      {
        'icon': Icon(Icons.calendar_today),
        'title': currentUser.birthday,
      },
      {
        'icon': Icon(Icons.pregnant_woman),
        'title': currentUser.gender,
      },
      {
        'icon': Icon(Icons.comment),
        'title': currentUser.comment,
      },
    ];
    return Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool scrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250.0,
                brightness: Brightness.dark,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      if (Platform.isIOS)
                        SizedBox(
                          width: 48.0,
                        ),
                      Expanded(
                        child: Text(
                          currentUser.username,
                          style: boldText.copyWith(
                              fontSize: fontXLg, color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: offsetBase,
                      ),
                      InkWell(
                        onTap: () {
                          _updateAvatar();
                        },
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: offsetBase,
                      ),
                    ],
                  ),
                  background: Image.network(
                    currentUser.imgurl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(offsetBase),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(offsetSm)),
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: offsetMd, vertical: offsetBase),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              NavigatorService(context).pushToWidget(
                                  screen: FriendListScreen(),
                                  pop: (val) async {
                                    await PreferenceService()
                                        .setFriendBadge(false);
                                    setState(() {
                                      isFriendBadge = false;
                                    });
                                  });
                            },
                            child: Row(
                              children: [
                                if (isFriendBadge)
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                  ),
                                if (isFriendBadge)
                                  SizedBox(
                                    width: offsetXSm,
                                  ),
                                Text(
                                  'Friends $friendCount',
                                  style: semiBold.copyWith(
                                      fontSize: fontMd,
                                      color: blueColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              NavigatorService(context).pushToWidget(
                                  screen: RequestScreen(),
                                  pop: (value) async {
                                    await PreferenceService()
                                        .setRequestBadge(false);
                                    _getRelate();
                                  });
                            },
                            child: Row(
                              children: [
                                if (isRequestBadge)
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                  ),
                                if (isRequestBadge)
                                  SizedBox(
                                    width: offsetXSm,
                                  ),
                                Text(
                                  'Request $requestCount',
                                  style: semiBold.copyWith(
                                      fontSize: fontMd,
                                      color: blueColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              NavigatorService(context).pushToWidget(
                                  screen: InviteScreen(),
                                  pop: (value) {
                                    _getRelate();
                                  });
                            },
                            child: Text(
                              'Invite',
                              style: semiBold.copyWith(
                                  fontSize: fontMd,
                                  color: blueColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: offsetBase,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(offsetSm)),
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: offsetMd, vertical: offsetBase),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: boldText.copyWith(
                              fontSize: fontMd,
                            ),
                          ),
                          SizedBox(
                            height: offsetBase,
                          ),
                          for (var item in aboutItems)
                            Column(
                              children: [
                                DividerWidget(),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: offsetXSm),
                                  child: Row(
                                    children: [
                                      item['icon'],
                                      SizedBox(
                                        width: offsetBase,
                                      ),
                                      Expanded(
                                        child: Text(
                                          item['title'],
                                          style: semiBold.copyWith(
                                              fontSize: fontBase),
                                          maxLines: 1,
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                          ),
                                          onPressed: () {
                                            _updateProfile(
                                                aboutItems.indexOf(item));
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: offsetBase,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(offsetSm)),
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: offsetMd, vertical: offsetXSm),
                      child: Row(
                        children: [
                          Icon(Icons.language),
                          SizedBox(
                            width: offsetBase,
                          ),
                          Text(
                            currentUser.language.isEmpty
                                ? 'English'
                                : currentUser.language,
                            style: semiBold.copyWith(fontSize: fontBase),
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: () {
                                DialogService(context).showSnackbar(
                                    notSupport, _scaffoldKey,
                                    type: SnackBarType.INFO);
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: offsetBase,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _updateProfile(int index) {
    switch (index) {
      case 0:
        _updateName();
        break;
      case 1:
        _updateEmail();
        break;
      case 2:
        _updateDOB();
        break;
      case 3:
        _updateGender();
        break;
      case 4:
        _updateCommit();
        break;
    }
  }

  _updateName() {
    _showUpdateDialog(
        content: 'Please input your name',
        hint: currentUser.username,
        update: (name) async {
          var param = {
            'id': currentUser.id,
            'name': name,
          };
          var resp = await NetworkService(context)
              .ajax('chat_update_name', param, isProgress: true);
          if (resp['ret'] == 10000) {
            currentUser.username = name;
            setState(() {});
          }
        });
  }

  _updateEmail() {
    if (currentUser.type != 'NORMAL') {
      DialogService(context).showSnackbar(
          'Your account is a social account', _scaffoldKey,
          type: SnackBarType.INFO);
      return;
    }
    _showUpdateDialog(
        content: 'Please input your email',
        hint: currentUser.email,
        keyboardType: TextInputType.emailAddress,
        update: (email) async {
          var param = {
            'id': currentUser.id,
            'email': email,
          };
          var resp = await NetworkService(context)
              .ajax('chat_update_email', param, isProgress: true);
          if (resp['ret'] == 10000) {
            currentUser.email = email;
            setState(() {});
          }
        });
  }

  _updateDOB() async {
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: DateFormat("yyyy-MM-dd").parse(currentUser.birthday),
      firstDate: DateTime(1901),
      lastDate: DateTime(2025),
    );
    print('selectedDate ===> $selectedDate');
    if (selectedDate != null) {
      String newDOB = DateFormat("yyyy-MM-dd").format(selectedDate);
      var param = {
        'id': currentUser.id,
        'birthday': newDOB,
      };
      var resp = await NetworkService(context)
          .ajax('chat_update_birthday', param, isProgress: true);
      if (resp['ret'] == 10000) {
        currentUser.birthday = newDOB;
        setState(() {});
      }
    }
  }

  _updateGender() {
    var chooseIconSize = 16.0;
    var choosePaddingSize = 2.0;
    print('currentUser ===> ${currentUser.gender}');
    DialogService(context)
        .showCustomModalBottomSheet(
            titleWidget: Padding(
              padding: const EdgeInsets.all(offsetBase),
              child: Text(
                'Choose Gender',
                style: boldText.copyWith(fontSize: 16.0),
              ),
            ),
            bodyWidget: Container(
              padding: EdgeInsets.symmetric(
                  vertical: offsetBase, horizontal: offsetLg),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop('MALE');
                    },
                    child: Row(
                      children: [
                        Container(
                          width: chooseIconSize,
                          height: chooseIconSize,
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(chooseIconSize / 2))),
                          child: currentUser.gender == 'MALE'
                              ? Container(
                                  margin: EdgeInsets.all(choosePaddingSize),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular((chooseIconSize -
                                                choosePaddingSize * 2) /
                                            2.0)),
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(
                          width: offsetMd,
                        ),
                        Text(
                          'Male',
                          style: semiBold.copyWith(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: offsetBase,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop('FEMALE');
                    },
                    child: Row(
                      children: [
                        Container(
                          width: chooseIconSize,
                          height: chooseIconSize,
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(chooseIconSize / 2))),
                          child: currentUser.gender == 'FEMALE'
                              ? Container(
                                  margin: EdgeInsets.all(choosePaddingSize),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular((chooseIconSize -
                                                choosePaddingSize * 2) /
                                            2.0)),
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(
                          width: offsetMd,
                        ),
                        Text(
                          'Female',
                          style: semiBold.copyWith(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        .then((value) async {
      if (value != null) {
        var param = {
          'id': currentUser.id,
          'gender': value,
        };
        var resp = await NetworkService(context)
            .ajax('chat_update_gender', param, isProgress: true);
        if (resp['ret'] == 10000) {
          currentUser.gender = value;
          setState(() {});
        }
      }
    });
  }

  _updateCommit() {
    _showUpdateDialog(
        content: 'Please input your comment',
        hint: currentUser.comment,
        update: (comment) async {
          var param = {
            'id': currentUser.id,
            'comment': comment,
          };
          var resp = await NetworkService(context)
              .ajax('chat_update_comment', param, isProgress: true);
          if (resp['ret'] == 10000) {
            currentUser.comment = comment;
            setState(() {});
          }
        });
  }

  _updateAvatar() {
    showPickerDialog();
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
                          _vidPicker(data['source']);
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

  _showUpdateDialog({
    @required String content,
    @required String hint,
    @required Function(String) update,
    TextInputType keyboardType = TextInputType.text,
  }) {
    var controller = TextEditingController();
    DialogService(context).showCustomDialog(
        titleWidget: Text(
          'Change Name',
          style: boldText.copyWith(fontSize: 16.0),
        ),
        bodyWidget: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
              vertical: offsetBase, horizontal: offsetBase),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: offsetSm),
                child: Text(
                  content,
                  style: mediumText.copyWith(fontSize: 16.0),
                ),
              ),
              UnderLineTextField(
                hint: hint,
                keyboardType: keyboardType,
                controller: controller,
                autofocus: true,
              )
            ],
          ),
        ),
        bottomWidget: Container(
          padding: EdgeInsets.symmetric(
              vertical: offsetBase, horizontal: offsetBase),
          child: Row(
            children: [
              Spacer(),
              Container(
                width: 100,
                height: 32,
                child: FullWidthButton(
                  title: 'Cancel',
                  color: Colors.red,
                  action: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
              SizedBox(
                width: offsetMd,
              ),
              Container(
                width: 100,
                height: 32,
                child: FullWidthButton(
                  title: 'Submit',
                  action: () {
                    if (controller.text.isEmpty) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    update(controller.text);
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ));
  }

  _imgPicker(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
        source: source, imageQuality: 50, maxWidth: 4000, maxHeight: 4000);

    String base64Thumbnail = await ImageService()
        .getThumbnailBase64FromImage(File(image.path), width: 320, height: 320);

    var param = {
      'id': currentUser.id,
      'base64': base64Thumbnail,
    };
    var resp = await NetworkService(context)
        .ajax('chat_update_avatar', param, isProgress: true);
    if (resp['ret'] == 10000) {
      currentUser.imgurl = resp['result'];
      setState(() {});
    }
  }

  _vidPicker(ImageSource source) async {
    PickedFile video = await ImagePicker().getVideo(source: source);

    String base64Thumbnail = await ImageService()
        .getThumbnailBase64FromVideo(File(video.path), width: 320, height: 320);
  }
}
