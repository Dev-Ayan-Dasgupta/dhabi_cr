// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecipientReceiveModeTile extends StatelessWidget {
  const RecipientReceiveModeTile({
    Key? key,
    required this.onTap,
    required this.title,
    this.limitAmount,
    this.limitCurrency,
    required this.feeAmount,
    required this.feeCurrency,
    required this.eta,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final String? limitAmount;
  final String? limitCurrency;
  final String feeAmount;
  final String feeCurrency;
  final String eta;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w)),
          boxShadow: [BoxShadows.primary],
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyles.primaryBold.copyWith(
                      color: const Color(0XFF1A3C40),
                      fontSize: (18 / Dimensions.designWidth).w,
                    ),
                  ),
                  SvgPicture.asset(
                    ImageConstants.arrowForwardIos,
                    width: (6.7 / Dimensions.designWidth).w,
                    height: (11.3 / Dimensions.designWidth).w,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              color: const Color(0XFFF9F9F9),
              child: Column(
                children: [
                  Ternary(
                    condition: limitAmount == null,
                    truthy: const SizeBox(),
                    falsy: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Limit",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0XFF1A3C40),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        Text(
                          "$limitAmount $limitCurrency",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0XFF1A3C40),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizeBox(height: limitAmount == null ? 0 : 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fee",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color(0XFF1A3C40),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        "$feeAmount $feeCurrency",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color(0XFF1A3C40),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 10),
                  Text(
                    eta,
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
