import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBarWidget(
        titleString: 'Membership',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetMd),
        child: Column(
          children: [
            Text('You are a ${isFree? 'free' : 'plus'} member',
              style: boldText.copyWith(fontSize: fontLg),
            ),
            SizedBox(height: offsetMd,),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(offsetMd),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  gradient: getGradientColor(color: blueColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Free Member',
                          style: boldText.copyWith(fontSize: fontLg, color: Colors.white),
                        ),
                        if (isFree) OutLineLabel(
                          title: 'Your Account',
                          titleColor: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: offsetBase, width: double.infinity,),
                    Text('Main Features',
                      style: boldText.copyWith(fontSize: fontMd, color: Colors.white),
                    ),
                    SizedBox(height: offsetSm),
                    for (var content in freeMemberFeature) Column(
                      children: [
                        Text(content,
                          style: mediumText.copyWith(fontSize: fontMd, color: Colors.white),
                        ),
                        SizedBox(height: offsetXSm),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: offsetMd,),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(offsetMd),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
                  gradient: getGradientColor(color: primaryColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Plus Member',
                          style: boldText.copyWith(fontSize: fontLg, color: Colors.white),
                        ),
                        isFree ? OutLineLabel(
                          title: '5\$ / Month',
                          titleColor: Colors.white,
                        ) : OutLineLabel(
                          title: 'Your Account',
                          titleColor: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: offsetBase, width: double.infinity,),
                    Text('Main Features',
                      style: boldText.copyWith(fontSize: fontMd, color: Colors.white),
                    ),
                    SizedBox(height: offsetSm),
                    for (var content in plusMemberFeature) Column(
                      children: [
                        Text(content,
                          style: mediumText.copyWith(fontSize: fontMd, color: Colors.white),
                        ),
                        SizedBox(height: offsetXSm),
                      ],
                    ),
                    SizedBox(height: offsetBase),
                    isFree ? OutLineLabel(
                      title: 'Upgrade Now',
                      titleColor: Colors.white,
                      fontSize: fontMd,
                    ) : Container(
                      child: Text(
                          'Your account will be expired in ${currentUser.expiredate.split(' ')[0]}.',
                        style: semiBold.copyWith(fontSize: fontMd, color: Colors.red),
                      ),
                    ),
                    Spacer(),
                    Text('Learn More',
                      style: semiBold.copyWith(fontSize: fontMd, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: offsetMd,),
          ],
        ),
      ),
    );
  }
}
