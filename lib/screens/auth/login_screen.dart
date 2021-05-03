import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:package_info/package_info.dart';
import 'package:simplechat/jsons/auth_json.dart';
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
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

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
    await _initPackageInfo();
    var resp = await NetworkService(context)
        .ajax('chat_status', null, isProgress: true);
    if (resp['ret'] == 10000) {
      appSettingInfo['isNearby'] = resp['result']['nearby'] == '1';
      appSettingInfo['isVideoStory'] = resp['result']['videostory'] == '1';
      appSettingInfo['isReplyComment'] = resp['result']['replycomment'] == '1';
      appSettingInfo['isVoiceCall'] = resp['result']['voicecall'] == '1';
      appSettingInfo['isVideoCall'] = resp['result']['videocall'] == '1';
      appSettingInfo['isAppVersion'] =
          checkVersion(resp['result']['appversion']);
      appSettingInfo['contactEmail'] = resp['result']['email'];
      appSettingInfo['contactPhone'] = resp['result']['phone'];

      print('appSettingInfo ===> ${appSettingInfo.toString()}');
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  bool checkVersion(String appVersion) {
    var currentVersions = _packageInfo.version.split('.');
    var difVersions = appVersion.split('.');

    var cValue = 0;
    var dValue = 0;

    for (var index = 0; index < currentVersions.length; index++) {
      var current = int.tryParse(currentVersions[index]);
      cValue = cValue * 10 + current;

      var dif = int.tryParse(difVersions[index]);
      dValue = dValue * 10 + dif;
    }
    print('cValue dValue ===> $cValue $dValue');
    return !(dValue > cValue);
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
                  SizedBox(width: offsetLg,),
                  for (var socialItem in socialLoginJson) if(socialItem['isShown']) Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _onSocialLogin(socialItem['type']);
                        },
                        child: SvgPicture.asset(socialItem['icon'],
                          width: socialItem['size'],
                          height: socialItem['size'],
                          color: socialItem['color'],
                        ),
                      ),
                      SizedBox(width: offsetLg,),
                    ],
                  ),
                  Spacer(),
                ],
              ),
              Spacer(flex: 1),
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

  _onSocialLogin(type) {
    switch (type) {
      case SocialType.APPLE:
        _onLoginApple();
        break;
      case SocialType.GOOGLE:
        _onLoginGoogle();
        break;
    }
  }

  _onLoginApple() async {
    String redirectionUri = 'https://simplechat.laodev.info/Backend/redirect_apple';
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: 'example-nonce',
      state: 'example-state',
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'simplechatservice',
        redirectUri: Uri.parse(
          redirectionUri,
        ),
      ),
    );

    try {
      Map<String, dynamic> payload = Jwt.parseJwt(credential.identityToken);
      String email = payload['email'] as String;
      var param = {
        'email' : email,
        'deviceid' : payload['sub'] as String,
        'name' : email.split('@').first,
      };
      var resp = await NetworkService(context)
          .ajax('chat_apple_login', param, isProgress: true);
      if (resp['ret'] == 10000) {
        currentUser = UserModel.fromMap(resp['result']);
        NavigatorService(context).pushToWidget(
          screen: MainScreen(),
          replace: true,
        );
      }
    } catch (e) {
      DialogService(context).showSnackbar('Error Apple Sign', _scaffoldKey, type: SnackBarType.ERROR);
    }
  }

  void _onLoginGoogle() async {
    
  }

  _onLoginEvent(String email, String pass) async {
    if (!appSettingInfo['isAppVersion']) {
      DialogService(context).showSnackbar(
          'Your app version is so low. Please update it.', _scaffoldKey,
          type: SnackBarType.WARING);
      return;
    }
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
