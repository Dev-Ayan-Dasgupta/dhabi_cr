// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({
    Key? key,
    required this.isCurrent,
  }) : super(key: key);

  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (2 / Dimensions.designWidth).w),
      child: Container(
        height: (9 / Dimensions.designWidth).w,
        width: isCurrent
            ? (17 / Dimensions.designWidth).w
            : (9 / Dimensions.designWidth).w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              (55 / Dimensions.designWidth).w,
            ),
          ),
          color: isCurrent ? AppColors.primary : const Color(0xFFD9D9D9),
        ),
      ),
    );
  }
}
