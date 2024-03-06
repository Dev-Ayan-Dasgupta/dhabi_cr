// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class DashboardBannerImage extends StatelessWidget {
  const DashboardBannerImage({
    Key? key,
    required this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (396 / Dimensions.designWidth).w,
      height: (109 / Dimensions.designWidth).w,
      margin: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((10 / Dimensions.designWidth).w),
        ),
        // TODO: Change this to Network image later
        image: DecorationImage(
          image: AssetImage(imgUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
