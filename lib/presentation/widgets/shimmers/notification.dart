import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ShimmerNotificationTile extends StatelessWidget {
  const ShimmerNotificationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomShimmer(
          child: ShimmerContainer(
            width: 100.w,
            height: ((100 / Dimensions.designHeight).h),
            borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w),
            ),
          ),
        ),
      ],
    );
  }
}
