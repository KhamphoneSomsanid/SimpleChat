import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Comment',
      ),
      body: Container(
        padding: EdgeInsets.all(offsetSm),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(offsetBase),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(offsetBase),
              ),
            )
          ],
        ),
      ),
    );
  }
}
