// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class LoanSummaryTile extends StatelessWidget {
  const LoanSummaryTile({
    Key? key,
    required this.currency,
    required this.disbursedAmount,
    required this.repaidAmount,
    required this.outstandingAmount,
  }) : super(key: key);

  final String currency;
  final double disbursedAmount;
  final double repaidAmount;
  final double outstandingAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all((20 / Dimensions.designWidth).w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((20 / Dimensions.designWidth).w),
        ),
        boxShadow: [BoxShadows.primary],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Disbursed Amount",
            style: TextStyles.primary.copyWith(
              color: AppColors.dark50,
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 5),
          Text(
            "$currency ${disbursedAmount >= 1000 ? NumberFormat('#,000.00').format(disbursedAmount) : disbursedAmount.toStringAsFixed(2)}",
            style: TextStyles.primary.copyWith(
              color: const Color(0XFF094148),
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 20),
          Stack(
            children: [
              Container(
                width: (350 / Dimensions.designWidth).w,
                height: (10 / Dimensions.designHeight).h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                  color: AppColors.dark30,
                ),
              ),
              Container(
                width: (repaidAmount / disbursedAmount) *
                    (350 / Dimensions.designWidth).w,
                height: (10 / Dimensions.designHeight).h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizeBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$currency $repaidAmount",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0XFF094148),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 5),
                  Text(
                    "Repaid",
                    style: TextStyles.primary.copyWith(
                      color: AppColors.dark50,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$currency ${outstandingAmount >= 1000 ? NumberFormat('#,000.00').format(outstandingAmount) : outstandingAmount.toStringAsFixed(2)}",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0XFF094148),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 5),
                  Text(
                    "Outstanding",
                    style: TextStyles.primary.copyWith(
                      color: AppColors.dark50,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
