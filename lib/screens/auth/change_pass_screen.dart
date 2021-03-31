import 'package:flutter/material.dart';
import 'package:simplechat/widgets/appbar_widget.dart';

class ChnagePassScreen extends StatefulWidget {
  final String email;

  const ChnagePassScreen({Key key, @required this.email}) : super(key: key);

  @override
  _ChnagePassScreenState createState() => _ChnagePassScreenState();
}

class _ChnagePassScreenState extends State<ChnagePassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Change Password',
      ),
    );
  }
}
