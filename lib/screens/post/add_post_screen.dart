import 'package:flutter/material.dart';
import 'package:simplechat/widgets/appbar_widget.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Add Post',
        actions: [

        ],
      ),
    );
  }
}
