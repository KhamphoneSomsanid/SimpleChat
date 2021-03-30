import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Forgot Password',
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
