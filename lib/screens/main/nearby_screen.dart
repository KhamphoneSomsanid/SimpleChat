import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/screens/setting/membership_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/button_widget.dart';
import 'package:simplechat/widgets/empty_widget.dart';

class NearByScreen extends StatefulWidget {
  @override
  _NearByScreenState createState() => _NearByScreenState();
}

class _NearByScreenState extends State<NearByScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var state = NearbyScreenState.LOADING;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _getNearByData();
    });
  }

  void _getNearByData() async {
    var param = {
      'id': currentUser.id,
    };

    var resp = await NetworkService(context)
        .ajax('chat_nearby_data', param, isProgress: true);
    if (resp['ret'] == 10000) {
    } else {
      setState(() {
        state = NearbyScreenState.EXPIRED;
      });
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.ERROR);
    }
  }

  _getContentView() {
    switch (state) {
      case NearbyScreenState.LOADING:
        return Center(
          child: EmptyWidget(
            title: 'Empty Nearby Data',
          ),
        );
      case NearbyScreenState.EXPIRED:
        return Center(
          child: Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                'assets/icons/ic_expire.svg',
                width: 120.0,
                height: 120.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: offsetLg),
                child: Text(
                  'Your account was expired, Please upgrade your membership. Try it again.',
                  style: boldText.copyWith(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ),
              FullWidthButton(
                title: 'Upgrade now',
                action: () {
                  NavigatorService(context).pushToWidget(
                      screen: MemberShipScreen(),
                      pop: (value) {
                        _getNearByData();
                      });
                },
              ),
              Spacer(),
            ],
          ),
        );
      case NearbyScreenState.NOREGISTER:
        return Container();
      case NearbyScreenState.SELLER:
        return Container();
      case NearbyScreenState.BUYER:
        return Container();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MainBarWidget(
        titleIcon: Container(
          padding: EdgeInsets.all(offsetBase),
          child: SvgPicture.asset(
            'assets/icons/ic_nearby.svg',
            color: primaryColor,
          ),
        ),
        titleString: 'Nearby',
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetBase),
        child: _getContentView(),
      ),
    );
  }
}

enum NearbyScreenState {
  LOADING,
  EXPIRED,
  NOREGISTER,
  SELLER,
  BUYER,
}
