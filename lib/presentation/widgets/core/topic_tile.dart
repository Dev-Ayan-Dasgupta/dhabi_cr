// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class TopicTile extends StatefulWidget {
  const TopicTile({
    Key? key,
    required this.onTap,
    required this.iconPath,
    required this.text,
    this.color,
    this.tappedColor,
    this.fontColor,
    this.highlightColor,
    this.iconColor,
    this.leading,
  }) : super(key: key);

  final VoidCallback onTap;
  final String iconPath;
  final String text;
  final Color? color;
  final Color? tappedColor;
  final Color? fontColor;
  final Color? highlightColor;
  final Color? iconColor;
  final Widget? leading;

  @override
  State<TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  bool isBeingTapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
      child: Container(
        padding: EdgeInsets.all((10 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          boxShadow: [BoxShadows.primary],
          color: isBeingTapped
              ? widget.tappedColor ?? AppColors.primary
              : widget.color ?? Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  widget.leading ??
                      Container(
                        width: (30 / Dimensions.designWidth).w,
                        height: (30 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((7 / Dimensions.designWidth).w),
                          ),
                          color: widget.highlightColor ??
                              const Color.fromRGBO(0, 184, 48, 0.1),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            widget.iconPath,
                            width: (15 / Dimensions.designWidth).w,
                            height: (15 / Dimensions.designHeight).h,
                            colorFilter: ColorFilter.mode(
                              isBeingTapped
                                  ? Colors.white
                                  : widget.iconColor ?? AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  const SizeBox(width: 10),
                  Text(
                    widget.text,
                    style: TextStyles.primaryMedium.copyWith(
                      fontSize: (18 / Dimensions.designWidth).w,
                      color: isBeingTapped
                          ? Colors.white
                          : widget.fontColor ?? const Color(0XFF1A3C40),
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              ImageConstants.arrowForwardIos,
              colorFilter: ColorFilter.mode(
                isBeingTapped
                    ? Colors.white
                    : widget.iconColor ?? AppColors.primary,
                BlendMode.srcIn,
              ),
              width: (6.7 / Dimensions.designWidth).w,
              height: (11.3 / Dimensions.designWidth).w,
            ),
          ],
        ),
      ),
    );
  }
}
