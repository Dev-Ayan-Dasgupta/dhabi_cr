// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class OnboardingStatusRow extends StatelessWidget {
  const OnboardingStatusRow({
    Key? key,
    required this.isCompleted,
    required this.isCurrent,
    required this.iconPath,
    required this.iconWidth,
    required this.iconHeight,
    required this.text,
    required this.dividerHeight,
  }) : super(key: key);

  final bool isCompleted;
  final bool isCurrent;
  final String iconPath;
  final double iconWidth;
  final double iconHeight;
  final String text;
  final double dividerHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  width: (38 / Dimensions.designWidth).w,
                  height: (38 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color:
                            isCurrent ? AppColors.primary : Colors.transparent,
                      ),
                      color: isCompleted
                          ? AppColors.primary
                          : isCurrent
                              ? const Color(0XFFF2F2F2)
                              : AppColors.dark30),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: (iconWidth / Dimensions.designWidth).w,
                      height: (iconHeight / Dimensions.designWidth).w,
                      colorFilter: ColorFilter.mode(
                        isCompleted ? Colors.white : AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (dividerHeight / Dimensions.designWidth).w,
                  child: VerticalDivider(
                    thickness: 2,
                    color: isCompleted ? AppColors.primary : AppColors.dark30,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizeBox(width: 20),
        Padding(
          padding: EdgeInsets.only(top: (10 / Dimensions.designWidth).w),
          child: Row(
            children: [
              SizedBox(
                width: (306 / Dimensions.designWidth).w,
                child: Text(
                  text,
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark80,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              ),
              SvgPicture.asset(
                ImageConstants.checkCircle,
                width: (20 / Dimensions.designWidth).w,
                height: (20 / Dimensions.designWidth).w,
                colorFilter: ColorFilter.mode(
                  isCompleted ? AppColors.green100 : AppColors.dark30,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
