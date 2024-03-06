import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
      ),
      child: Column(
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              CustomShimmer(
                child: ShimmerContainer(
                  width: (88 / Dimensions.designWidth).w,
                  height: (39 / Dimensions.designHeight).h,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
              const SizeBox(width: 10),
              CustomShimmer(
                child: ShimmerContainer(
                  width: (88 / Dimensions.designWidth).w,
                  height: (39 / Dimensions.designHeight).h,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
              const SizeBox(width: 10),
              CustomShimmer(
                child: ShimmerContainer(
                  width: (88 / Dimensions.designWidth).w,
                  height: (39 / Dimensions.designHeight).h,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
            ],
          ),
          const SizeBox(height: 20),
          Row(
            children: [
              CustomShimmer(
                child: ShimmerContainer(
                  width: (190 / Dimensions.designWidth).w,
                  height: (138 / Dimensions.designHeight).h,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
              const SizeBox(width: 10),
              CustomShimmer(
                child: ShimmerContainer(
                  width: (190 / Dimensions.designWidth).w,
                  height: (138 / Dimensions.designHeight).h,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
            ],
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomShimmer(
                child: ShimmerContainer(
                  width: (10 / Dimensions.designWidth).w,
                  height: (10 / Dimensions.designWidth).w,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
              const SizeBox(width: 5),
              CustomShimmer(
                child: ShimmerContainer(
                  width: (10 / Dimensions.designWidth).w,
                  height: (10 / Dimensions.designWidth).w,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
            ],
          ),
          const SizeBox(height: 20),
          CustomShimmer(
            child: ShimmerContainer(
              width: (64 / Dimensions.designWidth).w,
              height: (64 / Dimensions.designWidth).w,
              borderRadius: BorderRadius.all(
                Radius.circular((64 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 10),
          CustomShimmer(
            child: ShimmerContainer(
              width: (82 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              borderRadius: BorderRadius.all(
                Radius.circular((3 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 20),
          CustomShimmer(
            child: ShimmerContainer(
              width: (396 / Dimensions.designWidth).w,
              height: (109 / Dimensions.designHeight).h,
              borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 20),
          CustomShimmer(
            child: ShimmerContainer(
              width: (396 / Dimensions.designWidth).w,
              height: (300 / Dimensions.designHeight).h,
              borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
