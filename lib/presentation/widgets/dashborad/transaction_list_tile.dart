// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class DashboardTransactionListTile extends StatelessWidget {
  const DashboardTransactionListTile({
    Key? key,
    required this.isCredit,
    required this.title,
    required this.name,
    required this.amount,
    required this.currency,
    required this.date,
    this.padding,
    required this.onTap,
  }) : super(key: key);

  final bool isCredit;
  final String title;
  final String name;
  final double amount;
  final String currency;
  final String date;
  final double? padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (padding ?? 0 / Dimensions.designWidth).w,
          vertical: (5 / Dimensions.designWidth).w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: (40 / Dimensions.designWidth).w,
                  height: (40 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        (7 / Dimensions.designWidth).w,
                      ),
                    ),
                    color: isCredit
                        ? const Color.fromRGBO(0, 184, 148, 0.2)
                        : const Color.fromRGBO(35, 98, 105, 0.2),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      ImageConstants.transaction,
                      width: (20.73 / Dimensions.designWidth).w,
                      height: (8.7 / Dimensions.designWidth).w,
                      colorFilter: isCredit
                          ? const ColorFilter.mode(
                              Color(0XFF00B894),
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(
                              AppColors.primaryDark,
                              BlendMode.srcIn,
                            ),
                    ),
                  ),
                ),
                const SizeBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 45.w,
                      child: Text(
                        title,
                        style: TextStyles.primary.copyWith(
                          color: AppColors.primary,
                          fontSize: (18 / Dimensions.designWidth).w,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // const SizeBox(height: 7),
                    // SizedBox(
                    //   width: 45.w,
                    //   child: Text(
                    //     name,
                    //     style: TextStyles.primary.copyWith(
                    //       color: AppColors.grey40,
                    //       fontSize: (14 / Dimensions.designWidth).w,
                    //     ),
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isCredit
                      ? "${amount >= 1000 ? NumberFormat('#,000.00').format(amount) : amount.toStringAsFixed(2)} $currency"
                      : "- ${amount >= 1000 ? NumberFormat('#,000.00').format(amount) : amount.toStringAsFixed(2)} $currency",
                  style: TextStyles.primaryBold.copyWith(
                    color:
                        isCredit ? AppColors.green100 : AppColors.primaryDark,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 7),
                Text(
                  date,
                  style: TextStyles.primary.copyWith(
                    color: AppColors.grey40,
                    fontSize: (14 / Dimensions.designWidth).w,
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
