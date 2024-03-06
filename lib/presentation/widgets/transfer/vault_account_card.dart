// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class VaultAccountCard extends StatelessWidget {
  const VaultAccountCard({
    Key? key,
    required this.isVault,
    required this.onTap,
    required this.title,
    this.imgUrl,
    required this.accountNo,
    required this.currency,
    required this.amount,
    required this.isSelected,
  }) : super(key: key);

  final bool isVault;
  final VoidCallback onTap;
  final String title;
  final String? imgUrl;
  final String accountNo;
  final String currency;
  final String amount;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          color: Colors.white,
          boxShadow: [BoxShadows.primary],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "$title ",
                      style: TextStyles.primaryBold.copyWith(
                        fontSize: (16 / Dimensions.designWidth).w,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    isVault
                        ? SizedBox(
                            width: (31 / Dimensions.designWidth).w,
                            height: (18 / Dimensions.designWidth).w,
                            child: Image.network(imgUrl!, fit: BoxFit.fill),
                          )
                        : const SizeBox(),
                  ],
                ),
                const SizeBox(height: 10),
                Text(
                  isVault
                      ? "**${accountNo.substring(accountNo.length - 4, accountNo.length)}"
                      : accountNo,
                  style: TextStyles.primaryMedium.copyWith(
                    fontSize: (16 / Dimensions.designWidth).w,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$currency ${double.parse(amount.replaceAll(',', '')).abs() >= 1000000000 ? "${(double.parse(amount.replaceAll(',', '')).abs() / 1000000000).toStringAsFixed(2)} B" : double.parse(amount.replaceAll(',', '')).abs() >= 1000000 ? "${(double.parse(amount.replaceAll(',', '')).abs() / 1000000).toStringAsFixed(2)} M" : double.parse(amount.replaceAll(',', '')).abs() >= 1000 ? NumberFormat('#,000.00').format(double.parse(amount.replaceAll(',', ''))) : double.parse(amount.replaceAll(',', '')).toStringAsFixed(2)} ",
                      style: TextStyles.primaryBold.copyWith(
                        fontSize: (16 / Dimensions.designWidth).w,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizeBox(height: 10),
                    Text(
                      labels[93]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        fontSize: (16 / Dimensions.designWidth).w,
                        color: AppColors.dark50,
                      ),
                    ),
                  ],
                ),
                const SizeBox(width: 20),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
