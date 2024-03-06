// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class FeeExchangeRate extends StatelessWidget {
  const FeeExchangeRate({
    Key? key,
    required this.transferFeeCurrency,
    required this.transferFee,
    required this.exchangeRateSenderCurrency,
    required this.exchangeRate,
    required this.exchangeRateReceiverCurrency,
  }) : super(key: key);

  final String transferFeeCurrency;
  final double transferFee;
  final String exchangeRateSenderCurrency;
  final double exchangeRate;
  final String exchangeRateReceiverCurrency;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Transfer fee",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0xFF424242),
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        const SizeBox(width: 10),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: (30 / Dimensions.designWidth).w,
                          child: const VerticalDivider(
                            thickness: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          width: (23 / Dimensions.designWidth).w,
                          height: (23 / Dimensions.designWidth).w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 2, color: AppColors.primary),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              ImageConstants.arrowOutward,
                              width: (7 / Dimensions.designWidth).w,
                              height: (7 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const SizeBox(width: 10),
                        Text(
                          "$transferFeeCurrency ${transferFee.toStringAsFixed(2)}",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0xFF424242),
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Exchange rate 1 $exchangeRateSenderCurrency",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0xFF424242),
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        const SizeBox(width: 10),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: (30 / Dimensions.designWidth).w,
                          child: const VerticalDivider(
                            thickness: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          width: (23 / Dimensions.designWidth).w,
                          height: (23 / Dimensions.designWidth).w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 2, color: AppColors.primary),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              ImageConstants.equals,
                              width: (7 / Dimensions.designWidth).w,
                              height: (7 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const SizeBox(width: 10),
                        Text(
                          "${exchangeRate.toStringAsFixed(4)} $exchangeRateReceiverCurrency",
                          style: TextStyles.primaryMedium.copyWith(
                            color: const Color(0xFF424242),
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: (30 / Dimensions.designWidth).w,
                child: const VerticalDivider(
                  thickness: 2,
                  color: AppColors.primary,
                ),
              ),
              const SizeBox(height: 10),
            ],
          ),
        ),
        Positioned(
          bottom: -(10 / Dimensions.designHeight).h,
          left: (177.5 / Dimensions.designWidth).w,
          child: Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.primary,
            size: (40 / Dimensions.designWidth).w,
          ),
        ),
      ],
    );
  }
}
