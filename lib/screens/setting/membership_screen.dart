import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/params.dart';
import 'package:simplechat/utils/themes.dart';
import 'package:simplechat/widgets/appbar_widget.dart';
import 'package:simplechat/widgets/label_widget.dart';

class MemberShipScreen extends StatefulWidget {
  @override
  _MemberShipScreenState createState() => _MemberShipScreenState();
}

class _MemberShipScreenState extends State<MemberShipScreen> {
  StreamSubscription _conectionSubscription;
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;

  final List<String> _productLists = [
    'com.laodev.simplechat.jobpost',
    'com.laodev.simplechat.membership',
  ];
  List<IAPItem> _items = [];
  // List<PurchasedItem> _purchases = [];

  var isFree = true;
  var freeMemberFeature = [
    '⋅ Add and post the story feature.',
    '· Post only 1 feed per a day.',
    '· Chat with your friend.',
    '· Send invite and accept the friend request.',
    '· Follow and share the post and story.',
  ];

  var plusMemberFeature = [
    '⋅ All free member feature.',
    '⋅ Unlimited the post feed.',
    '⋅ Voice and video calling feature.',
    '· Post your job using nearby.',
  ];

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  @override
  void dispose() {
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription.cancel();
      _purchaseErrorSubscription = null;
    }
    super.dispose();
  }

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // refresh items for android
    // try {
    //   String msg = await FlutterInappPurchase.instance.consumeAllItems;
    //   print('consumeAllItems: $msg');
    // } catch (err) {
    //   print('consumeAllItems error: $err');
    // }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });

    _getProduct();
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId);
  }

  Future _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      // this._purchases = [];
    });
  }

  // Future _getPurchases() async {
  //   List<PurchasedItem> items =
  //   await FlutterInappPurchase.instance.getAvailablePurchases();
  //   for (var item in items) {
  //     print('${item.toString()}');
  //     this._purchases.add(item);
  //   }

  //   setState(() {
  //     this._items = [];
  //     this._purchases = items;
  //   });
  // }

  // Future _getPurchaseHistory() async {
  //   List<PurchasedItem> items = await FlutterInappPurchase.instance.getPurchaseHistory();
  //   for (var item in items) {
  //     print('${item.toString()}');
  //     this._purchases.add(item);
  //   }

  //   setState(() {
  //     this._items = [];
  //     this._purchases = items;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Membership',
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
        child: Column(
          children: [
            Text(
              'You are a ${isFree ? 'free' : 'plus'} member',
              style: boldText.copyWith(fontSize: fontLg),
            ),
            SizedBox(
              height: offsetMd,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(offsetMd),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  gradient: getGradientColor(color: blueColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Free Member',
                          style: boldText.copyWith(
                              fontSize: fontMd, color: Colors.white),
                        ),
                        if (isFree)
                          OutLineLabel(
                            title: 'Your Account',
                            titleColor: Colors.white,
                          ),
                      ],
                    ),
                    SizedBox(
                      height: offsetSm,
                      width: double.infinity,
                    ),
                    Text(
                      'Main Features',
                      style: boldText.copyWith(
                          fontSize: fontBase, color: Colors.white),
                    ),
                    SizedBox(height: offsetSm),
                    for (var content in freeMemberFeature)
                      Column(
                        children: [
                          Text(
                            content,
                            style: mediumText.copyWith(
                                fontSize: fontBase, color: Colors.white),
                          ),
                          SizedBox(height: 2.0),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: offsetMd,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(offsetMd),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  gradient: getGradientColor(color: primaryColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Plus Member',
                          style: boldText.copyWith(
                              fontSize: fontMd, color: Colors.white),
                        ),
                        isFree
                            ? OutLineLabel(
                                title: '5\$ / Month',
                                titleColor: Colors.white,
                              )
                            : OutLineLabel(
                                title: 'Your Account',
                                titleColor: Colors.white,
                              ),
                      ],
                    ),
                    SizedBox(
                      height: offsetSm,
                      width: double.infinity,
                    ),
                    Text(
                      'Main Features',
                      style: boldText.copyWith(
                          fontSize: fontBase, color: Colors.white),
                    ),
                    SizedBox(height: offsetSm),
                    for (var content in plusMemberFeature)
                      Column(
                        children: [
                          Text(
                            content,
                            style: mediumText.copyWith(
                                fontSize: fontBase, color: Colors.white),
                          ),
                          SizedBox(height: 2.0),
                        ],
                      ),
                    SizedBox(height: offsetBase),
                    isFree
                        ? InkWell(
                            onTap: () {
                              if (_items.isEmpty) return;
                              _requestPurchase(_items[1]);
                            },
                            child: OutLineLabel(
                              title: 'Upgrade Now',
                              titleColor: Colors.white,
                              fontSize: fontBase,
                            ),
                          )
                        : Container(
                            child: Text(
                              'Your account will be expired in ${currentUser.expiredate.split(' ')[0]}.',
                              style: semiBold.copyWith(
                                  fontSize: fontBase, color: Colors.red),
                            ),
                          ),
                    Spacer(),
                    Text(
                      'Learn More',
                      style: semiBold.copyWith(
                          fontSize: fontMd, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: offsetMd,
            ),
          ],
        ),
      ),
    );
  }
}
