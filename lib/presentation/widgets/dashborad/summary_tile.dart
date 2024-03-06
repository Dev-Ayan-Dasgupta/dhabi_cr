// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class AccountSummaryTile extends StatelessWidget {
  const AccountSummaryTile({
    Key? key,
    required this.onTap,
    required this.imgUrl,
    required this.accountType,
    this.accountNumber,
    required this.currency,
    required this.amount,
    required this.subText,
    required this.subImgUrl,
    this.fontSize,
    this.space,
    this.isShowCheckMark,
    this.isSelected,
    this.isShowOverdue,
  }) : super(key: key);

  final VoidCallback onTap;
  final String imgUrl;
  final String accountType;
  final String? accountNumber;
  final String currency;
  final String amount;
  final String subText;
  final String subImgUrl;
  final double? fontSize;
  final double? space;
  final bool? isShowCheckMark;
  final bool? isSelected;
  final bool? isShowOverdue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (188 / Dimensions.designWidth).w,
        padding: EdgeInsets.symmetric(
          horizontal: (15 / Dimensions.designWidth).w,
          vertical: (20 / Dimensions.designWidth).w,
        ),
        margin: EdgeInsets.only(
          right: (15 / Dimensions.designWidth).w,
          top: (2 / Dimensions.designWidth).w,
          bottom: (2 / Dimensions.designWidth).w,
        ),
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
                CustomCircleAvatarAsset(imgUrl: imgUrl),
                const SizeBox(width: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accountType,
                          style: TextStyles.primary.copyWith(
                            color: const Color(0xFF9F9F9F),
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        Ternary(
                          condition: isShowCheckMark ?? false,
                          falsy: const SizeBox(),
                          truthy: Text(
                            accountNumber ?? "",
                            style: TextStyles.primary.copyWith(
                              color: const Color(0xFF9F9F9F),
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        Ternary(
                          condition: isShowOverdue ?? false,
                          falsy: const SizeBox(),
                          truthy: Text(
                            accountNumber ?? "",
                            style: TextStyles.primary.copyWith(
                              color: AppColors.red100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Ternary(
                      condition: isShowCheckMark ?? false,
                      truthy: const SizeBox(width: 10),
                      falsy: const SizeBox(),
                    ),
                    Ternary(
                      condition: isShowCheckMark ?? false,
                      truthy: Container(
                        width: (15 / Dimensions.designWidth).w,
                        height: (15 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: isSelected == true ? 0 : 0.5,
                            color: AppColors.dark50,
                          ),
                        ),
                        child: isSelected == true
                            ? SvgPicture.asset(
                                ImageConstants.checkCircle,
                                width: (15 / Dimensions.designWidth).w,
                                height: (15 / Dimensions.designWidth).w,
                              )
                            : const SizeBox(),
                      ),
                      falsy: const SizeBox(),
                    ),
                  ],
                ),
              ],
            ),
            SizeBox(height: subText.isEmpty ? space ?? 40 : 15),
            RichText(
              text: TextSpan(
                text: "$currency ",
                style: TextStyles.primary.copyWith(
                  color: AppColors.primary,
                  fontSize: ((fontSize ?? 20) / Dimensions.designWidth).w,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: amount == "" ||
                            amount.contains("M") ||
                            amount.contains("B")
                        ? amount
                        : double.parse(amount.replaceAll(',', '')) >= 1000
                            ? NumberFormat('#,000.00').format(
                                double.parse(amount.replaceAll(',', '')))
                            : double.parse(amount.replaceAll(',', ''))
                                .toStringAsFixed(2),
                    style: TextStyles.primary.copyWith(
                        color: AppColors.primary,
                        fontSize: ((fontSize ?? 20) / Dimensions.designWidth).w,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Ternary(
              condition: subText.isNotEmpty,
              truthy: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subText,
                    style: TextStyles.primary.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  Container(
                    width: (40 / Dimensions.designWidth).w,
                    height: (26 / Dimensions.designWidth).w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(subImgUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
              falsy: const SizeBox(),
            ),
          ],
        ),
      ),
    );
  }
}
