// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatementTypeTile extends StatelessWidget {
  const StatementTypeTile({
    Key? key,
    required this.onTap,
    required this.iconPath,
    required this.text,
    this.color,
  }) : super(key: key);

  final VoidCallback onTap;
  final String iconPath;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (116 / Dimensions.designWidth).w,
        padding: EdgeInsets.all(
          (10 / Dimensions.designWidth).w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w)),
          boxShadow: [BoxShadows.primary],
          color: color ?? Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: (58 / Dimensions.designWidth).w,
              height: (95 / Dimensions.designHeight).h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: const Color.fromRGBO(26, 53, 64, 0.5),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: (25 / Dimensions.designWidth).w,
                  height: (25 / Dimensions.designWidth).w,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF1A3640), BlendMode.srcIn),
                ),
              ),
            ),
            const SizeBox(height: 10),
            Text(
              text,
              style: TextStyles.primary.copyWith(
                color: AppColors.primary,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
