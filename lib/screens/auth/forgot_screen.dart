import 'package:flutter/material.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/screens/auth/change_pass_screen.dart';
import 'package:simplechat/services/common_service.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  var isEnabled = false;
  var isVerified = false;

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      onTextChangeListener();
    });
  }

  void onTextChangeListener() {
    String email = emailController.text;
    setState(() {
      if (email.length > 0 && email.contains('@') && email.contains('.')) {
        isEnabled = true;
      } else {
        isEnabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MainBarWidget(
          titleString: 'Forgot Password',
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
          child: Column(
            children: [
              Text(
                'Please enter your email.',
                style: semiBold.copyWith(fontSize: fontMd),
              ),
              SizedBox(
                height: offsetBase,
              ),
              UnderLineTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                label: 'Email',
                fontSize: fontMd,
                sufficIcon: Icon(Icons.email),
              ),
              if (isVerified)
                SizedBox(
                  height: offsetBase,
                ),
              if (isVerified)
                UnderLineTextField(
                  controller: codeController,
                  keyboardType: TextInputType.text,
                  label: 'Code',
                  fontSize: fontMd,
                  sufficIcon: Icon(Icons.code),
                ),
              SizedBox(
                height: offsetLg,
              ),
              FullWidthButton(
                title: isVerified ? 'Submit' : 'Send Code',
                action: isEnabled
                    ? () {
                        isVerified ? _sendCode() : _submit();
                      }
                    : null,
              ),
              Spacer(),
              Text(
                'If you didn\'t get a verification code yet?',
                style: semiBold.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                height: offsetSm,
              ),
              InkWell(
                onTap: () {
                  _resendCode();
                },
                child: Text(
                  'Resend code',
                  style: semiBold.copyWith(
                      fontSize: fontBase,
                      color: blueColor,
                      decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(
                height: offsetLg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendCode() async {
    String email = emailController.text;
    var param = {
      'email': email,
    };
    var resp = await NetworkService(context)
        .ajax('chat_email_verify', param, isProgress: true);
    if (resp['ret'] == 10000) {
      isVerified = true;
      setState(() {});
    }
  }

  void _resendCode() async {
    String email = emailController.text;
    var param = {'email': email};
    var resp = await NetworkService(context)
        .ajax('chat_resend_code', param, isProgress: false);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
    }
  }

  void _submit() async {
    String email = emailController.text;
    String code = codeController.text;
    String deviceid = await getId();
    var param = {
      'email': email,
      'code': code,
      'deviceid': deviceid,
    };

    var resp = await NetworkService(context)
        .ajax('chat_confirm_code', param, isProgress: true);
    if (resp['ret'] == 10000) {
      currentUser = UserModel.fromMap(resp['result']);
      DialogService(context).showSnackbar('content', _scaffoldKey, dismiss: () {
        NavigatorService(context).pushToWidget(
            screen: ChnagePassScreen(
              email: email,
            ),
            replace: true);
      });
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.ERROR);
    }
  }
}
