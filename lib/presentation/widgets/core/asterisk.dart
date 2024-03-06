// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class Asterisk extends StatelessWidget {
  const Asterisk({
    Key? key,
    this.color,
    this.fontSize,
  }) : super(key: key);

  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      " *",
      style: TextStyles.primaryMedium.copyWith(
        color: color ?? AppColors.red100,
        fontSize: ((fontSize ?? 16) / Dimensions.designWidth).w,
      ),
    );
  }
}
