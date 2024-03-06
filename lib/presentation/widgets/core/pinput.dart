// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:pinput/pinput.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class CustomPinput extends StatefulWidget {
  const CustomPinput({
    Key? key,
    required this.pinController,
    this.pinColor,
    required this.onChanged,
    this.enabled,
  }) : super(key: key);

  final TextEditingController pinController;
  final Color? pinColor;
  final Function(String) onChanged;
  final bool? enabled;

  @override
  State<CustomPinput> createState() => _CustomPinputState();
}

class _CustomPinputState extends State<CustomPinput> {
  @override
  Widget build(BuildContext context) {
    return Pinput(
      autofocus: true,
      length: 6,
      controller: widget.pinController,
      defaultPinTheme: PinTheme(
        width: (45 / Dimensions.designWidth).w,
        height: (45 / Dimensions.designWidth).w,
        textStyle: TextStyles.primaryMedium.copyWith(
          color: AppColors.black25,
          fontSize: (24 / Dimensions.designWidth).w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          color: widget.pinColor ?? const Color(0xFFEEEEEE),
        ),
      ),
      onChanged: widget.onChanged,
      enabled: widget.enabled ?? true,
    );
  }
}
