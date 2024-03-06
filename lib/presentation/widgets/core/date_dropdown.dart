// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DateDropdown extends StatelessWidget {
  const DateDropdown({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w)),
          // boxShadow: [BoxShadows.primary],
          border: Border.all(color: const Color(0XFFEEEEEE), width: 1),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyles.primary.copyWith(
                color: isSelected ? const Color(0XFF252525) : AppColors.grey40,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            SvgPicture.asset(
              ImageConstants.date,
              width: (14 / Dimensions.designWidth).w,
              height: (16 / Dimensions.designWidth).w,
            ),
          ],
        ),
      ),
    );
  }
}
