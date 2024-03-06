// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplicationProgress extends StatelessWidget {
  const ApplicationProgress({
    Key? key,
    required this.progress,
  }) : super(key: key);

  final int progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: (24 / Dimensions.designWidth).w,
              height: (24 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: Center(
                child: progress > 1
                    ? SvgPicture.asset(
                        ImageConstants.checkCircle,
                        width: (24 / Dimensions.designWidth).w,
                        height: (24 / Dimensions.designWidth).w,
                        colorFilter: const ColorFilter.mode(
                            AppColors.primary, BlendMode.srcIn),
                      )
                    : Text(
                        "1",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
              ),
            ),
            Container(
              width: (94 / Dimensions.designWidth).w,
              height: (5 / Dimensions.designWidth).w,
              color: progress > 1 ? AppColors.primary : AppColors.dark30,
            ),
            Column(
              children: [
                Container(
                  width: (24 / Dimensions.designWidth).w,
                  height: (24 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primary, width: progress == 2 ? 1 : 0),
                  ),
                  child: Center(
                    child: progress > 2
                        ? SvgPicture.asset(
                            ImageConstants.checkCircle,
                            width: (24 / Dimensions.designWidth).w,
                            height: (24 / Dimensions.designWidth).w,
                            colorFilter: const ColorFilter.mode(
                                AppColors.primary, BlendMode.srcIn),
                          )
                        : progress == 2
                            ? Text(
                                "2",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.primary,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              )
                            : Container(
                                width: (24 / Dimensions.designWidth).w,
                                height: (24 / Dimensions.designWidth).w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0XFFD9D9D9),
                                ),
                              ),
                  ),
                ),
              ],
            ),
            Container(
              width: (94 / Dimensions.designWidth).w,
              height: (5 / Dimensions.designWidth).w,
              color: progress > 2 ? AppColors.primary : AppColors.dark30,
            ),
            Container(
              width: (24 / Dimensions.designWidth).w,
              height: (24 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary, width: progress == 3 ? 1 : 0),
              ),
              child: Center(
                child: progress > 3
                    ? SvgPicture.asset(
                        ImageConstants.checkCircle,
                        width: (24 / Dimensions.designWidth).w,
                        height: (24 / Dimensions.designWidth).w,
                        colorFilter: const ColorFilter.mode(
                            AppColors.primary, BlendMode.srcIn),
                      )
                    : progress == 3
                        ? Text(
                            "3",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          )
                        : Container(
                            width: (24 / Dimensions.designWidth).w,
                            height: (24 / Dimensions.designWidth).w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0XFFD9D9D9),
                            ),
                          ),
              ),
            ),
            Container(
              width: (94 / Dimensions.designWidth).w,
              height: (5 / Dimensions.designWidth).w,
              color: progress > 3 ? AppColors.primary : AppColors.dark30,
            ),
            Container(
              width: (24 / Dimensions.designWidth).w,
              height: (24 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary, width: progress == 4 ? 1 : 0),
              ),
              child: Center(
                child: progress > 4
                    ? SvgPicture.asset(
                        ImageConstants.checkCircle,
                        width: (24 / Dimensions.designWidth).w,
                        height: (24 / Dimensions.designWidth).w,
                        colorFilter: const ColorFilter.mode(
                            AppColors.primary, BlendMode.srcIn),
                      )
                    : progress == 4
                        ? Text(
                            "4",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          )
                        : Container(
                            width: (24 / Dimensions.designWidth).w,
                            height: (24 / Dimensions.designWidth).w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0XFFD9D9D9),
                            ),
                          ),
              ),
            ),
          ],
        ),
        const SizeBox(height: 8),
        Row(
          children: [
            const SizeBox(width: 3),
            Text(
              labels[29]["labelText"],
              style: TextStyles.primary.copyWith(
                color: AppColors.dark50,
                fontSize: (12 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(width: 77),
            Text(
              labels[262]["labelText"],
              style: TextStyles.primary.copyWith(
                color: AppColors.dark50,
                fontSize: (12 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(width: 87),
            Text(
              labels[263]["labelText"],
              style: TextStyles.primary.copyWith(
                color: AppColors.dark50,
                fontSize: (12 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(width: 85),
            Text(
              labels[78]["labelText"],
              style: TextStyles.primary.copyWith(
                color: AppColors.dark50,
                fontSize: (12 / Dimensions.designWidth).w,
              ),
            ),
          ],
        )
      ],
    );
  }
}
