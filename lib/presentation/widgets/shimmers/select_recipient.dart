import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ShimmerSelectRecipientTile extends StatelessWidget {
  const ShimmerSelectRecipientTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomShimmer(
                  child: ShimmerContainer(
                    width: (35 / Dimensions.designWidth).w,
                    height: (35 / Dimensions.designWidth).w,
                    borderRadius: BorderRadius.all(
                      Radius.circular((10 / Dimensions.designWidth).w),
                    ),
                  ),
                ),
                const SizeBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                      child: ShimmerContainer(
                        width: (75 / Dimensions.designWidth).w,
                        height: (8 / Dimensions.designHeight).h,
                        borderRadius: BorderRadius.all(
                          Radius.circular((10 / Dimensions.designWidth).w),
                        ),
                      ),
                    ),
                    const SizeBox(height: 10),
                    CustomShimmer(
                      child: ShimmerContainer(
                        width: (100 / Dimensions.designWidth).w,
                        height: (8 / Dimensions.designHeight).h,
                        borderRadius: BorderRadius.all(
                          Radius.circular((10 / Dimensions.designWidth).w),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomShimmer(
                  child: ShimmerContainer(
                    width: (100 / Dimensions.designWidth).w,
                    height: (8 / Dimensions.designHeight).h,
                    borderRadius: BorderRadius.all(
                      Radius.circular((10 / Dimensions.designWidth).w),
                    ),
                  ),
                ),
                const SizeBox(height: 10),
                CustomShimmer(
                  child: ShimmerContainer(
                    width: (25 / Dimensions.designWidth).w,
                    height: (8 / Dimensions.designHeight).h,
                    borderRadius: BorderRadius.all(
                      Radius.circular((10 / Dimensions.designWidth).w),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
