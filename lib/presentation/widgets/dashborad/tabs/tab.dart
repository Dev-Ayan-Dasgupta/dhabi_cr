// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/utils/constants/index.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key? key,
    required this.title,
    required this.isSelected,
  }) : super(key: key);
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (20 / Dimensions.designWidth).w,
        vertical: (10 / Dimensions.designHeight).h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((10 / Dimensions.designWidth).w),
        ),
        image: isSelected
            ? const DecorationImage(
                image: AssetImage(ImageConstants.buttonGradient),
                fit: BoxFit.fill,
              )
            : null,
        // color: isSelected ? const Color(0XFFE8EBEC) : Colors.transparent,
      ),
      child: Text(
        title,
        style: TextStyles.primaryMedium.copyWith(
          color: isSelected ? Colors.white : AppColors.dark80,
          fontSize: (14 / Dimensions.designWidth).w,
        ),
      ),
    );
  }
}
