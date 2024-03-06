// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SolidButton extends StatelessWidget {
  const SolidButton({
    Key? key,
    required this.onTap,
    this.width,
    this.height,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.color,
    this.auxWidget,
    required this.text,
    this.subtitle,
    this.fontColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final Widget? auxWidget;
  final String text;
  final String? subtitle;
  final Color? fontColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 100.w,
        height: height ?? (50 / Dimensions.designHeight).h,
        decoration: BoxDecoration(
          border:
              Border.all(color: borderColor ?? Colors.transparent, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? (10 / Dimensions.designWidth).w),
          ),
          boxShadow: boxShadow ?? [],
          color: color ?? AppColors.dark30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                auxWidget ?? const SizeBox(),
                Text(
                  text,
                  style: TextStyles.primaryBold.copyWith(
                    color: fontColor ?? AppColors.dark50,
                    fontSize: fontSize ?? (18 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
            SizeBox(height: subtitle != null ? 3 : 0),
            Ternary(
              condition: subtitle != null,
              truthy: Text(
                subtitle ?? "",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: fontSize ?? (12 / Dimensions.designWidth).w,
                ),
              ),
              falsy: const SizeBox(),
            ),
          ],
        ),
      ),
    );
  }
}
