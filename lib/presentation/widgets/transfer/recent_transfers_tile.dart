// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class RecentTransferTile extends StatelessWidget {
  const RecentTransferTile({
    Key? key,
    required this.onTap,
    required this.name,
    required this.status,
    required this.amount,
    required this.currency,
    required this.accountNumber,
    required this.iconPath,
  }) : super(key: key);

  final VoidCallback onTap;
  final String name;
  final String status;
  final String amount;
  final String currency;
  final String accountNumber;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: (5 / Dimensions.designHeight).h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: (35 / Dimensions.designWidth).w,
              height: (35 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((7 / Dimensions.designWidth).w),
                ),
                color: const Color.fromRGBO(0, 184, 48, 0.1),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: (15 / Dimensions.designWidth).w,
                  height: (15 / Dimensions.designHeight).h,
                ),
              ),
            ),
            const SizeBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 5),
                  Row(
                    children: [
                      Text(
                        accountNumber,
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$currency ${double.parse(amount) >= 1000 ? NumberFormat('#,000.00').format(double.parse(amount.replaceAll(',', ''))) : double.parse(amount).toStringAsFixed(2)}",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 5),
                Text(
                  status,
                  style: TextStyles.primaryMedium.copyWith(
                    color: status == "Pending"
                        ? AppColors.orange100
                        : status == "Success"
                            ? AppColors.green100
                            : AppColors.red100,
                    fontSize: (12 / Dimensions.designWidth).w,
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
