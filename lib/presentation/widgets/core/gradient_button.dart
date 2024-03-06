// ignore_for_file: public_member_api_docs, sort_constructors_firsts

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({
    Key? key,
    required this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient,
    required this.text,
    this.auxWidget,
    this.fontColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Gradient? gradient;
  final String text;
  final Widget? auxWidget;
  final Color? fontColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool isBeingTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleEnd: (details) {
        setState(() {
          isBeingTapped = false;
        });
      },
      onTapDown: (value) {
        setState(() {
          isBeingTapped = true;
        });
      },
      onTapUp: (value) async {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          isBeingTapped = false;
        });
      },
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: widget.width ?? 100.w,
        height: widget.height ?? (50 / Dimensions.designHeight).h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
                widget.borderRadius ?? (10 / Dimensions.designHeight).h),
          ),
          color: isBeingTapped ? AppColors.primaryDark : Colors.transparent,
          image: isBeingTapped
              ? null
              : const DecorationImage(
                  image: AssetImage(ImageConstants.buttonGradient),
                  fit: BoxFit.fill,
                ),
          // gradient: gradient ??
          //     const LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [
          //         Color(0xFF1A3C40),
          //         Color(0xFF236269),
          //         Color(0xFF1A3C40),
          //       ],
          //     ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyles.primary.copyWith(
                fontSize: widget.fontSize ?? (18 / Dimensions.designWidth).w,
                fontWeight: widget.fontWeight ?? FontWeight.w700,
              ),
            ),
            widget.auxWidget ?? const SizeBox(),
          ],
        ),
      ),
    );
  }
}
