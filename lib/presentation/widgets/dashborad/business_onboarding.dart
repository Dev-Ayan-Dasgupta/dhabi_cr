// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessDashboardOnboarding extends StatelessWidget {
  const BusinessDashboardOnboarding({
    Key? key,
    required this.progress,
    required this.stage1,
    required this.stage2,
    required this.onTap1,
    required this.onTap2,
  }) : super(key: key);

  final double progress;
  final bool stage1;
  final bool stage2;
  final VoidCallback onTap1;
  final VoidCallback onTap2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: (260 / Dimensions.designWidth).w,
      padding: EdgeInsets.all((20 / Dimensions.designWidth).w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular((20 / Dimensions.designWidth).w),
          topRight: Radius.circular((20 / Dimensions.designWidth).w),
        ),
        boxShadow: [BoxShadows.primary],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get you onboarded",
            style: TextStyles.primary.copyWith(
              color: AppColors.primary,
              fontSize: (24 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 20),
          Row(
            children: [
              SvgPicture.asset(ImageConstants.dot),
              const SizeBox(width: 7),
              Text(
                "${(progress * 100).toStringAsFixed(0)}% Complete",
                style: TextStyles.primary.copyWith(
                  color: const Color.fromRGBO(9, 9, 9, 0.4),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(width: 7),
              Stack(
                children: [
                  Container(
                    width: (262 / Dimensions.designWidth).w,
                    height: (10 / Dimensions.designWidth).w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((10 / Dimensions.designWidth).w),
                      ),
                      color: AppColors.dark30,
                    ),
                  ),
                  Container(
                    width: progress * (262 / Dimensions.designWidth).w,
                    height: (10 / Dimensions.designWidth).w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((10 / Dimensions.designWidth).w),
                      ),
                      color: AppColors.primary,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizeBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardStageTile(
                onTap: onTap1,
                isCompleted: stage1,
                statusIconPath: stage1
                    ? ImageConstants.checkCircle
                    : ImageConstants.warningSmall,
                iconPath: ImageConstants.phoneAndroid,
                text: labels[227]["labelText"],
              ),
              const SizeBox(width: 20),
              DashboardStageTile(
                color: const Color(0xFFF0F0F0),
                onTap: onTap2,
                isCompleted: stage2,
                statusIconPath: stage2
                    ? ImageConstants.checkCircle
                    : ImageConstants.warningSmall,
                iconPath: ImageConstants.article,
                text: labels[261]["labelText"],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
