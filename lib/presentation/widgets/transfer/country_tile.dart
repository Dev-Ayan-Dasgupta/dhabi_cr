// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    Key? key,
    required this.onTap,
    required this.flagImgUrl,
    required this.country,
    required this.currencyCode,
    required this.supportedCurrencies,
    required this.currencies,
  }) : super(key: key);

  final VoidCallback onTap;
  final String flagImgUrl;
  final String country;
  final String currencyCode;
  final List<dynamic> supportedCurrencies;
  final List<String> currencies;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: (10 / Dimensions.designWidth).w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: ((30 / 2) / Dimensions.designWidth).w,
                  backgroundImage: MemoryImage(
                    base64Decode(flagImgUrl),
                  ),
                ),
                const SizeBox(width: 20),
                Text(
                  country,
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
            Text(
              currencies.join(" • "),
              // currencyCode,
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.dark50,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
