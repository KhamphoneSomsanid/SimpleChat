import 'package:flutter/material.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Add Project',
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
