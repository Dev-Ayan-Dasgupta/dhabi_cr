// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(
          horizontal: (25 / Dimensions.designWidth).w,
          vertical: (15 / Dimensions.designWidth).w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    offset: Offset((4 / Dimensions.designWidth).w,
                        (4 / Dimensions.designWidth).w),
                    blurRadius: (8 / Dimensions.designWidth).w,
                    color: const Color.fromRGBO(0, 0, 0, 0.1),
                  ),
                ]
              : [],
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: (25 / Dimensions.designWidth).w,
              height: (25 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.dark30,
                  width: isSelected ? 0 : 1,
                ),
              ),
              child: Center(
                child: isSelected
                    ? SvgPicture.asset(
                        ImageConstants.checkCircle,
                        width: (25 / Dimensions.designWidth).w,
                        height: (25 / Dimensions.designWidth).w,
                      )
                    : const SizeBox(),
              ),
            ),
            const SizeBox(width: 25),
            Text(
              text,
              style: TextStyles.primary.copyWith(
                color: AppColors.primaryDark,
                fontSize: (18 / Dimensions.designWidth).w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
