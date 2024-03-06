import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ShimmerLoanDetails extends StatelessWidget {
  const ShimmerLoanDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizeBox(height: 7),
        CustomShimmer(
          child: ShimmerContainer(
            width: (75 / Dimensions.designWidth).w,
            height: (8 / Dimensions.designHeight).h,
            borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w),
            ),
          ),
        ),
        const SizeBox(height: 20),
        CustomShimmer(
          child: ShimmerContainer(
            width: (150 / Dimensions.designWidth).w,
            height: (8 / Dimensions.designHeight).h,
            borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w),
            ),
          ),
        ),
        const SizeBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                const SizeBox(height: 7),
                CustomShimmer(
                  child: ShimmerContainer(
                    width: (75 / Dimensions.designWidth).w,
                    height: (8 / Dimensions.designHeight).h,
                    borderRadius: BorderRadius.all(
                      Radius.circular((10 / Dimensions.designWidth).w),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                const SizeBox(height: 7),
                CustomShimmer(
                  child: ShimmerContainer(
                    width: (75 / Dimensions.designWidth).w,
                    height: (8 / Dimensions.designHeight).h,
                    borderRadius: BorderRadius.all(
                      Radius.circular((10 / Dimensions.designWidth).w),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
