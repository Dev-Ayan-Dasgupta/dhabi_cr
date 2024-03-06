// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.onTap,
    required this.name,
    required this.iban,
    required this.bic,
    required this.flagImgUrl,
    required this.accountNumber,
    required this.accountType,
    required this.currency,
    required this.balance,
  }) : super(key: key);

  final VoidCallback onTap;
  final String name;
  final String iban;
  final String bic;
  final String flagImgUrl;
  final String accountNumber;
  final String accountType;
  final String currency;
  final String balance;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: ((35 / 2) / Dimensions.designWidth).w,
                    backgroundImage: MemoryImage(
                      base64Decode(flagImgUrl),
                    ),
                  ),
                  const SizeBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Balance",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "$currency ",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                          Text(
                            balance,
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.primary,
                              fontSize: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                accountType,
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
          const SizeBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account Number",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 7),
              Text(
                accountNumber,
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
          const SizeBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "IBAN",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 7),
              Row(
                children: [
                  Text(
                    iban,
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  // const SizeBox(width: 10),
                  // InkWell(
                  //   onTap: () {
                  //     Clipboard.setData(
                  //       ClipboardData(
                  //         text: iban,
                  //       ),
                  //     );
                  //   },
                  //   child: SvgPicture.asset(
                  //     ImageConstants.contentCopy,
                  //     width: (17 / Dimensions.designWidth).w,
                  //     height: (20 / Dimensions.designWidth).w,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          const SizeBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BIC",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 7),
                  Text(
                    bic,
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onTap,
                child: SvgPicture.asset(
                  ImageConstants.share,
                  width: (18 / Dimensions.designWidth).w,
                  height: (18 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
