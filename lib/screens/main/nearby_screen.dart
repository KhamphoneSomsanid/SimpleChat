import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/models/nearby_model.dart';
import 'package:simplechat/screens/setting/membership_screen.dart';
import 'package:simplechat/services/dialog_service.dart';
import 'package:simplechat/services/navigator_service.dart';
import 'package:simplechat/services/network_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
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
      if (resp['result'] == null) {
        state = NearbyScreenState.NOREGISTER;
      } else {
        currentNearby = NearbyModel.fromMap(resp['result']);
        if (currentNearby.type == nearbyTypeSeller) {
          state = NearbyScreenState.SELLER;
        } else {
          state = NearbyScreenState.BUYER;
        }
      }
    } else {
      state = NearbyScreenState.EXPIRED;
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.ERROR);
    }
    setState(() {});
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
        return Container(
          padding: EdgeInsets.symmetric(horizontal: offsetMd),
          child: Column(
            children: [
              Spacer(),
              Container(
                width: 120, height: 120,
                padding: EdgeInsets.all(offsetLg),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_nearby.svg',
                  color: Colors.white,),
              ),
              SizedBox(height: offsetXLg, width: double.infinity,),
              Text('Welcome to Nearby!',
                textAlign: TextAlign.center,
                style: boldText.copyWith(fontSize: fontLg),),
              SizedBox(height: offsetBase,),
              Text('You can start your business from here\nPlease choose your business type.',
                textAlign: TextAlign.center,
                style: mediumText.copyWith(fontSize: fontMd),),
              SizedBox(height: offsetXLg,),
              FullWidthButton(
                title: 'Join to Buyer',
                action: () {
                  joinNearby(nearbyTypeBuyer);
                },
              ),
              SizedBox(height: offsetMd,),
              FullWidthButton(
                title: 'Join to Seller',
                color: blueColor,
                action: () {
                  joinNearby(nearbyTypeSeller);
                },
              ),
              Spacer(),
            ],
          ),
        );
      case NearbyScreenState.SELLER:
        return Container();
      case NearbyScreenState.BUYER:
        return Column(
          children: [
            Text('My projects', style: semiBold.copyWith(fontSize: fontMd),),

          ],
        );
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

  void joinNearby(String type) async {
    var param = {
      'userid': currentUser.id,
      'type' : type,
    };
    var resp = await NetworkService(context)
        .ajax('chat_nearby_join', param, isProgress: true);
    if (resp['ret'] == 10000) {
      currentNearby = NearbyModel.fromMap(resp['result']);
      if (currentNearby.type == nearbyTypeSeller) {
        state = NearbyScreenState.SELLER;
      } else {
        state = NearbyScreenState.BUYER;
      }
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey,);
    } else {
      DialogService(context)
          .showSnackbar(resp['msg'], _scaffoldKey, type: SnackBarType.ERROR);
    }
    setState(() {});
  }

}

enum NearbyScreenState {
  LOADING,
  EXPIRED,
  NOREGISTER,
  SELLER,
  BUYER,
}
