import 'package:flutter/material.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainBarWidget(
        titleString: 'Privacy and Policy',
      ),
      body: WebView(
        initialUrl: privacyUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
