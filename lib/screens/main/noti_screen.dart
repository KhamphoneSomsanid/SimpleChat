import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/models/notification_model.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';
import 'package:simplechat/widgets/textfield_widget.dart';

class NotiScreen extends StatefulWidget {
  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<NotificationModel> models = [];
  List<NotificationModel> showModels = [];

  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      filterData();
    });
  }

  void filterData() {
    String search = searchController.text;
    showModels.clear();
    for (var model in models) {
      if (model.isContainKey(search)) {
        showModels.add(model);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MainBarWidget(
        titleIcon: Container(
          padding: EdgeInsets.all(offsetBase),
          child: SvgPicture.asset(
            'assets/icons/ic_notification_on.svg',
            color: primaryColor,
          ),
        ),
        titleString: 'Notifications',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetSm),
        child: Column(
          children: [
            SearchWidget(
              searchController: searchController,
              onClear: () {
                setState(() {
                  searchController.text = '';
                });
              },
              onChanged: (value) {},
            ),
            SizedBox(
              height: offsetSm,
            ),
            Expanded(
                child: showModels.isEmpty
                    ? EmptyWidget(title: 'The notification data is not existed yet.',)
                    : ListView.builder(
                  itemCount: showModels.length,
                  itemBuilder: (context, i) {
                    return Container();
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }
}
