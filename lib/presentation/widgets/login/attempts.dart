// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class LoginAttempt extends StatelessWidget {
  const LoginAttempt({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
          vertical: (16 / Dimensions.designHeight).h),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular((3 / Dimensions.designWidth).w)),
        color: const Color(0xFFEEEEEE),
      ),
      child: Text(
        message,
        style: TextStyles.primaryMedium.copyWith(
          color: AppColors.red100,
          fontSize: (16 / Dimensions.designWidth).w,
        ),
      ),
    );
  }
}
