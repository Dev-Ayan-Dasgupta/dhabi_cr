import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class BoxShadows {
  static BoxShadow primary = BoxShadow(
    color: const Color.fromRGBO(0, 0, 0, 0.1),
    offset:
        Offset((4 / Dimensions.designWidth).w, (4 / Dimensions.designWidth).w),
    blurRadius: 10,
  );

  static BoxShadow primaryInverted = BoxShadow(
    color: const Color.fromRGBO(0, 0, 0, 0.1),
    offset: Offset(
        (-4 / Dimensions.designWidth).w, (-4 / Dimensions.designWidth).w),
    blurRadius: 10,
  );
}
