import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/models/nearby_project_model.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/empty_widget.dart';

class NearbyBuyerWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NearbyBuyerWidget({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _NearbyBuyerWidgetState createState() => _NearbyBuyerWidgetState();
}

class _NearbyBuyerWidgetState extends State<NearbyBuyerWidget> {
  List<NearbyProjectModel> projects = [];

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getBuyerData();
    });
  }

  _getBuyerData() async {
    var param = {
      'id': currentUser.id,
    };
    var resp = await NetworkService(context)
        .ajax('chat_buyer_data', param, isProgress: true);
    if (resp['ret'] == 10000) {
      projects.clear();
      for (var json in resp['result']) {
        var project = NearbyProjectModel.fromMap(json);
        if (project != null) {
          projects.add(project);
        }
      }
    } else {
      DialogService(context).showSnackbar(resp['msg'], widget.scaffoldKey,
          type: SnackBarType.ERROR);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return projects.isEmpty
        ? EmptyWidget(
            title:
                'Not found any project for you. Please try to creaet a new project.',
          )
        : Column(
            children: [],
          );
  }
}
