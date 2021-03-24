import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class EmptyWidget extends StatelessWidget {
  final String title;

  const EmptyWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: offsetMd),
      child: Column(
        children: [
          Spacer(),
          Container(
            width: 120, height: 120,
            padding: EdgeInsets.all(offsetXMd),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
            ),
            child: SvgPicture.asset('assets/icons/ic_empty.svg'),
          ),
          SizedBox(height: offsetXLg,),
          Text(title,
            textAlign: TextAlign.center,
            style: semiBold.copyWith(fontSize: fontMd),),
          Spacer(),
        ],
      ),
    );
  }
}
