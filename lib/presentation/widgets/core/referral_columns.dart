import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ReferralColumns extends StatelessWidget {
  const ReferralColumns({
    Key? key,
    required this.title,
    required this.count,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (20 / Dimensions.designWidth).w,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyles.primaryMedium.copyWith(
              fontSize: (14 / Dimensions.designWidth).w,
              color: isSelected ? AppColors.dark80 : AppColors.dark80,
            ),
          ),
          const SizeBox(height: 10),
          Text(
            "$count",
            style: TextStyles.primaryMedium.copyWith(
              fontSize: (20 / Dimensions.designWidth).w,
              color: isSelected ? AppColors.dark80 : AppColors.dark80,
            ),
          ),
        ],
      ),
    );
  }
}
