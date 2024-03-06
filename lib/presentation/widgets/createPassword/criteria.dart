// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class PasswordCriteria extends StatelessWidget {
  const PasswordCriteria({
    Key? key,
    this.criteria1Color,
    this.criteria2Color,
    this.criteria3Color,
    this.criteria4Color,
    this.criteria1Widget,
    this.criteria2Widget,
    this.criteria3Widget,
    this.criteria4Widget,
  }) : super(key: key);

  final Color? criteria1Color;
  final Color? criteria2Color;
  final Color? criteria3Color;
  final Color? criteria4Color;

  final Widget? criteria1Widget;
  final Widget? criteria2Widget;
  final Widget? criteria3Widget;
  final Widget? criteria4Widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all((10 / Dimensions.designWidth).w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((3 / Dimensions.designWidth).w),
        ),
        color: const Color(0xFFEEEEEE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labels[50]["labelText"],
            style: TextStyles.primaryBold.copyWith(
              color: AppColors.primaryDark,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labels[51]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: criteria1Color ?? AppColors.red100,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              criteria1Widget ?? const SizeBox(),
            ],
          ),
          const SizeBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labels[52]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: criteria2Color ?? AppColors.red100,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              criteria2Widget ?? const SizeBox(),
            ],
          ),
          const SizeBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labels[53]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: criteria3Color ?? AppColors.red100,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              criteria3Widget ?? const SizeBox(),
            ],
          ),
          const SizeBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labels[54]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: criteria4Color ?? AppColors.red100,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              criteria4Widget ?? const SizeBox(),
            ],
          ),
        ],
      ),
    );
  }
}
