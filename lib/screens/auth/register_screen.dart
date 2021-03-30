import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var dateController = TextEditingController();
  var commentController = TextEditingController();
  var passwordController = TextEditingController();
  var repassController = TextEditingController();
  var isPassShow = false;
  var isRepassShow = false;
  var isRegister = false;

  PickedFile _image;
  DateTime selectedDate = DateTime(1990, 1, 1);

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      checkRegister();
    });
    nameController.addListener(() {
      checkRegister();
    });
    passwordController.addListener(() {
      checkRegister();
    });
    repassController.addListener(() {
      checkRegister();
    });
    dateController.addListener(() {
      checkRegister();
    });
    commentController.addListener(() {
      checkRegister();
    });

    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  void checkRegister() {
    if (_image == null) {
      setState(() {
        isRegister = false;
      });
      return;
    }
    String email = emailController.text;
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      setState(() {
        isRegister = false;
      });
      return;
    }
    String birthday = dateController.text;
    if (birthday.isEmpty) {
      setState(() {
        isRegister = false;
      });
      return;
    }
    String comment = commentController.text;
    if (comment.isEmpty) {
      setState(() {
        isRegister = false;
      });
      return;
    }
    String username = nameController.text;
    if (username.isEmpty) {
      setState(() {
        isRegister = false;
      });
      return;
    }
    String password = passwordController.text;
    String repass = repassController.text;
    if (password.isEmpty || password != repass) {
      setState(() {
        isRegister = false;
      });
      return;
    }
    setState(() {
      isRegister = true;
    });
  }

  _imgPicker(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
        source: source, imageQuality: 50, maxWidth: 1000, maxHeight: 1000);

    setState(() {
      _image = image;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1921, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    dateController.dispose();
    commentController.dispose();
    passwordController.dispose();
    repassController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MainBarWidget(
          titleString: 'Register',
          titleIcon: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: InkWell(
                    onTap: () {
                      showPickerDialog();
                    },
                    child: Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.file(
                                  File(_image.path),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60.0)),
                                child: Icon(Icons.account_circle, size: 120.0),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: offsetLg,
                ),
                UnderLineTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  label: 'Email',
                  fontSize: fontMd,
                  sufficIcon: Icon(Icons.email),
                ),
                SizedBox(
                  height: offsetBase,
                ),
                UnderLineTextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  label: 'Username',
                  fontSize: fontMd,
                  sufficIcon: Icon(Icons.account_circle),
                ),
                SizedBox(
                  height: offsetBase,
                ),
                UnderLineTextField(
                  controller: dateController,
                  label: 'Birthday',
                  isReadOnly: true,
                  fontSize: fontMd,
                  sufficIcon: Icon(Icons.perm_contact_calendar),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                SizedBox(
                  height: offsetBase,
                ),
                UnderLineTextField(
                  controller: commentController,
                  keyboardType: TextInputType.text,
                  label: 'Comment',
                  fontSize: fontMd,
                  sufficIcon: Icon(Icons.help),
                ),
                SizedBox(
                  height: offsetBase,
                ),
                UnderLineTextField(
                  controller: passwordController,
                  label: 'Password',
                  fontSize: fontMd,
                  sufficIcon: InkWell(
                      onTap: () {
                        setState(() {
                          isPassShow = !isPassShow;
                        });
                      },
                      child: Icon(!isPassShow
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined)),
                  isPassword: !isPassShow,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(
                  height: offsetBase,
                ),
                UnderLineTextField(
                  controller: repassController,
                  label: 'Confirm Password',
                  fontSize: fontMd,
                  sufficIcon: InkWell(
                      onTap: () {
                        setState(() {
                          isRepassShow = !isRepassShow;
                        });
                      },
                      child: Icon(!isRepassShow
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined)),
                  isPassword: !isRepassShow,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(
                  height: offsetLg,
                ),
                FullWidthButton(
                  title: 'Register',
                  action: isRegister
                      ? () {
                          register();
                        }
                      : null,
                ),
                SizedBox(
                  height: offsetBase,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    print('register');

    FocusScope.of(context).unfocus();

    String email = emailController.text;
    String username = nameController.text;
    String birthday = dateController.text;
    String comment = commentController.text;
    String password = passwordController.text;

    var param = {
      'email': email,
      'name': username,
      'password': password,
      'birthday' : birthday,
      'comment' : comment,
    };

    if (_image != null) {
      List<int> imageBytes = File(_image.path).readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      param['base64'] = base64Image;
    }

    var resp = await NetworkService(context)
        .ajax('chat_register', param, isProgress: true);
    if (resp['ret'] == 10000) {
      DialogService(context)
          .showSnackbar('Successfully user register', _scaffoldKey);
      Navigator.of(context).pop();
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.ERROR);
    }
  }

  void showPickerDialog() {
    var pickers = [
      {
        'icon': Icons.image,
        'title': 'From Gallery',
        'source': ImageSource.gallery,
        'color': primaryColor
      },
      {
        'icon': Icons.camera_alt,
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
              'Choose Image',
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
              height: offsetBase,
            ),
            for (var data in pickers)
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  _imgPicker(data['source']);
                },
                child: Container(
                  width: 200.0,
                  padding: EdgeInsets.symmetric(
                      horizontal: offsetBase, vertical: offsetSm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        data['icon'],
                        size: 24,
                        color: data['color'],
                      ),
                      Text(
                        data['title'],
                        style: semiBold.copyWith(
                            fontSize: fontMd, color: data['color']),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
