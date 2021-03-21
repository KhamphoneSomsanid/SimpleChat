import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/models/user_model.dart';
import 'package:simplechat/services/common_service.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({Key key, this.email}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var codeController = TextEditingController();
  var isEnabled = false;

  @override
  void initState() {
    super.initState();

    codeController.addListener(() {
      String code = codeController.text;
      setState(() {
        if (code.length == 6) {
          isEnabled = true;
        } else {
          isEnabled = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: MainBarWidget(
          titleString: 'Verification Email',
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
          child: Column(
            children: [
              SizedBox(
                height: offsetLg,
              ),
              Container(
                width: 120.0,
                height: 120.0,
                padding: EdgeInsets.all(offsetLg),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_secret.svg',
                  width: 60.0,
                  height: 60.0,
                ),
              ),
              SizedBox(
                height: offsetLg,
              ),
              Text(
                'SimpleChat just sent a verification code to your email: ',
                textAlign: TextAlign.center,
                style: semiBold.copyWith(fontSize: fontMd),
              ),
              SizedBox(
                height: offsetSm,
              ),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: boldText.copyWith(fontSize: fontMd, color: blueColor),
              ),
              SizedBox(
                height: offsetBase,
              ),
              UnderLineTextField(
                controller: codeController,
                keyboardType: TextInputType.text,
                label: 'Verify Code',
                fontSize: fontMd,
                sufficIcon: Icon(Icons.lock),
              ),
              SizedBox(
                height: offsetLg,
              ),
              Text(
                'If you don\'t receive a verification code,',
                textAlign: TextAlign.center,
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                height: offsetSm,
              ),
              InkWell(
                onTap: () {
                  resendCode();
                },
                child: Text(
                  'Resend Code',
                  textAlign: TextAlign.center,
                  style:
                      semiBold.copyWith(fontSize: fontMd, color: primaryColor),
                ),
              ),
              SizedBox(
                height: offsetLg,
              ),
              FullWidthButton(
                title: 'Submit',
                action: isEnabled
                    ? () {
                        submit();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resendCode() async {
    var param = {'email': widget.email};
    var resp = await NetworkService(context)
        .ajax('chat_resend_code', param, isProgress: false);
    if (resp['ret'] == 10000) {
      DialogService(context).showSnackbar(resp['msg'], _scaffoldKey);
    }
  }

  void submit() async {
    String code = codeController.text;
    String deviceid = await getId();
    var param = {
      'email': widget.email,
      'code': code,
      'deviceid': deviceid,
    };

    var resp = await NetworkService(context)
        .ajax('chat_confirm_code', param, isProgress: true);
    if (resp['ret'] == 10000) {
      currentUser = UserModel.fromMap(resp['result']);
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop();
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.ERROR);
    }
  }
}
