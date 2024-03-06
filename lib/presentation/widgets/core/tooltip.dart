// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    Key? key,
    required this.tooltiptap,
    required this.content,
    required this.show,
    required this.onTap,
  }) : super(key: key);

  final Function()? tooltiptap;
  final String content;
  final bool show;
  final VoidCallback onTap;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  @override
  Widget build(BuildContext context) {
    return SimpleTooltip(
      animationDuration: const Duration(milliseconds: 300),
      tooltipTap: widget.tooltiptap,
      ballonPadding: EdgeInsets.all((3 / Dimensions.designWidth).w),
      borderWidth: 0,
      borderRadius: (5 / Dimensions.designWidth).w,
      arrowLength: (7 / Dimensions.designWidth).w,
      arrowBaseWidth: (15 / Dimensions.designWidth).w,
      backgroundColor: AppColors.black25,
      content: Material(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: AppColors.black25),
            color: AppColors.black25,
          ),
          child: Text(
            widget.content,
            style: TextStyles.primary.copyWith(
              color: Colors.white,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ),
      ),
      show: widget.show,
      child: HelpSnippet(
        onTap: widget.onTap,
      ),
    );
  }
}
