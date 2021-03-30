import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/screens/auth/forgot_screen.dart';
import 'package:simplechat/screens/main_screen.dart';
import 'package:simplechat/screens/auth/register_screen.dart';
import 'package:simplechat/screens/auth/verify_screen.dart';
import 'package:simplechat/services/common_service.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/services/pref_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isPassShow = false;
  var isRemember = false;
  var isLoginEnabled = false;

  var pref = PreferenceService();

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      onTextChangeListener();
    });
    passwordController.addListener(() {
      onTextChangeListener();
    });

    initData();

    Timer.run(() {
      _getData();
    });
  }

  void _getData() async {
    var resp = await NetworkService(context)
        .ajax('chat_status', null, isProgress: true);
    if (resp['ret'] == 10000) {
      appSettingInfo['isNearby'] = resp['result']['nearby'] == '1';
      appSettingInfo['isVideoStory'] = resp['result']['videostory'] == '1';
      appSettingInfo['isReplyComment'] = resp['result']['replycomment'] == '1';
      appSettingInfo['isVoiceCall'] = resp['result']['voicecall'] == '1';
      appSettingInfo['isVideoCall'] = resp['result']['videocall'] == '1';

      print('appSettingInfo ===> ${appSettingInfo.toString()}');
    }
  }

  Future<void> initData() async {
    pref.init();
    var isRemember = await pref.getRemember();
    if (isRemember != null && isRemember) {
      String email = await pref.getEmail();
      String password = await pref.getPassword();
      emailController.text = email;
      passwordController.text = password;

      setState(() {});
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void onTextChangeListener() {
    String email = emailController.text;
    String password = passwordController.text;
    setState(() {
      if (email.length > 0 &&
          email.contains('@') &&
          email.contains('.') &&
          password.length > 0) {
        isLoginEnabled = true;
      } else {
        isLoginEnabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
          child: Column(
            children: [
              Spacer(),
              Image.asset(
                'assets/icons/ic_logo.png',
                color: primaryColor,
                width: 180,
                fit: BoxFit.fitWidth,
              ),
              Spacer(),
              UnderLineTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                label: 'Email',
                fontSize: fontMd,
                sufficIcon: Icon(Icons.email),
              ),
              SizedBox(
                height: offsetLg,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isRemember = !isRemember;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          isRemember
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: offsetSm,
                        ),
                        Text(
                          'Remember me',
                          style: semiBold.copyWith(
                              fontSize: fontBase, color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        NavigatorService(context)
                            .pushToWidget(screen: ForgotPassScreen());
                      },
                      child: Text(
                        'Forgot Pass?',
                        style: semiBold.copyWith(
                            fontSize: fontBase, color: blueColor),
                      ))
                ],
              ),
              Spacer(flex: 2),
              FullWidthButton(
                title: 'Login',
                action: isLoginEnabled
                    ? () {
                        String email = emailController.text;
                        String pass = passwordController.text;
                        _onLoginEvent(email, pass);
                      }
                    : null,
              ),
              Spacer(flex: 2),
              Row(
                children: [
                  Spacer(),
                  Text(
                    'If you have not account yet?',
                    style: mediumText.copyWith(fontSize: fontBase),
                  ),
                  SizedBox(
                    width: offsetSm,
                  ),
                  InkWell(
                      onTap: () {
                        NavigatorService(context).pushToWidget(
                          screen: RegisterScreen(),
                        );
                      },
                      child: Text(
                        'Go to Register!',
                        style: mediumText.copyWith(
                            fontSize: fontBase, color: primaryColor),
                      )),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: offsetBase,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onLoginEvent(String email, String pass) async {
    FocusScope.of(context).unfocus();

    String deviceID = await getId();

    var param = {
      'email': email,
      'deviceid': deviceID,
      'password': pass,
    };
    var resp = await NetworkService(context)
        .ajax('chat_login', param, isProgress: true);

    if (resp['ret'] == 10000) {
      if (isRemember) {
        pref.setEmail(email);
        pref.setPassword(pass);
        pref.setRemember(true);
      }

      currentUser = UserModel.fromMap(resp['result']);
      NavigatorService(context).pushToWidget(
        screen: MainScreen(),
        replace: true,
      );
    } else if (resp['ret'] == 10002) {
      if (isRemember) {
        pref.setEmail(email);
        pref.setPassword(pass);
        pref.setRemember(true);
      }

      NavigatorService(context).pushToWidget(
          screen: VerifyScreen(
            email: email,
          ),
          pop: (value) {
            if (value != null) {
              NavigatorService(context).pushToWidget(
                screen: MainScreen(),
                replace: true,
              );
            }
          });
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.ERROR);
    }
  }
}
