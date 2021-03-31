import 'package:flutter/material.dart';
import 'package:simplechat/screens/auth/success_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class ChnagePassScreen extends StatefulWidget {
  final String email;

  const ChnagePassScreen({Key key, @required this.email}) : super(key: key);

  @override
  _ChnagePassScreenState createState() => _ChnagePassScreenState();
}

class _ChnagePassScreenState extends State<ChnagePassScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repassController = TextEditingController();

  var isPassShow = false;
  var isRepassShow = false;
  var isEnabled = false;

  @override
  void initState() {
    super.initState();

    passwordController.addListener(() {
      onChangeTextListener();
    });
    repassController.addListener(() {
      onChangeTextListener();
    });
  }

  void onChangeTextListener() {
    String password = passwordController.text;
    String repass = repassController.text;
    isEnabled = password == repass;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MainBarWidget(
          titleString: 'Change Password',
          actions: [
            IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  _helpChangePass();
                })
          ],
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
          child: Column(
            children: [
              UnderLineTextField(
                controller: passwordController,
                label: 'Password',
                fontSize: fontBase,
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
                fontSize: fontBase,
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
                title: 'Change Password',
                action: isEnabled
                    ? () {
                        _changePassword();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    FocusScope.of(context).unfocus();

    String pass = passwordController.text;
    var param = {
      'pass': pass,
      'email': widget.email,
    };
    var resp = await NetworkService(context)
        .ajax('chat_change_pass', param, isProgress: true);
    if (resp['ret'] == 10000) {
      NavigatorService(context).pushToWidget(
          screen: SuccessScreen(title: 'Successfully the changing password'),
          replace: true);
    }
  }

  void _helpChangePass() async {
    await DialogService(context).showCustomModalBottomSheet(
        titleWidget: Container(
            padding: EdgeInsets.all(offsetBase),
            child: Text(
              'Change Password',
              style: semiBold.copyWith(fontSize: fontMd),
            )),
        bodyWidget: Container(
          padding: EdgeInsets.all(offsetBase),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The password should contain like below',
                style: semiBold.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                height: offsetSm,
              ),
              Text(
                'at least a upcase character. (A ~ Z)',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                height: offsetXSm,
              ),
              Text(
                'at least a lowcase character. (a ~ z)',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                height: offsetXSm,
              ),
              Text(
                'at least a number character. (0 ~ 9)',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                height: offsetXSm,
              ),
              Text(
                'at least a special character.',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
              SizedBox(
                height: offsetXSm,
              ),
              Text(
                'at least 8 characters.',
                style: mediumText.copyWith(fontSize: fontBase),
              ),
            ],
          ),
        ));
  }
}
