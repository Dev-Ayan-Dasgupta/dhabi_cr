// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class DashboardStageTile extends StatelessWidget {
  const DashboardStageTile({
    Key? key,
    required this.onTap,
    required this.isCompleted,
    required this.statusIconPath,
    required this.iconPath,
    required this.text,
    this.color,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isCompleted;
  final String statusIconPath;
  final String iconPath;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: (116 / Dimensions.designWidth).w,
            padding: EdgeInsets.all(
              (10 / Dimensions.designWidth).w,
            ),
            decoration: BoxDecoration(
              boxShadow: [BoxShadows.primary],
              color: color ?? Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  width: (58 / Dimensions.designWidth).w,
                  height: (58 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: isCompleted
                          ? AppColors.primary
                          : const Color.fromRGBO(161, 161, 161, 0.19),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(iconPath),
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
          Positioned(
            top: (10 / Dimensions.designWidth).w,
            right: (10 / Dimensions.designWidth).w,
            child: SvgPicture.asset(
              statusIconPath,
              width: (15 / Dimensions.designWidth).w,
              height: (15 / Dimensions.designWidth).w,
              colorFilter: isCompleted
                  ? const ColorFilter.mode(Color(0XFF00B894), BlendMode.srcIn)
                  : const ColorFilter.mode(Color(0XFFD9D9D9), BlendMode.srcIn),
            ),
          )
        ],
      ),
    );
  }
}
