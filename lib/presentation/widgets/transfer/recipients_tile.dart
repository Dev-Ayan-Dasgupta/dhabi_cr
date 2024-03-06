// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class RecipientsTile extends StatelessWidget {
  const RecipientsTile({
    Key? key,
    required this.onTap,
    required this.flagImgUrl,
    required this.name,
    required this.accountNumber,
    required this.currency,
    required this.bankName,
    required this.isBank,
    required this.onDelete,
    required this.beneficiaryStatus,
  }) : super(key: key);

  // final bool isWithinDhabi;
  final VoidCallback onTap;
  final String flagImgUrl;
  final String name;
  final String accountNumber;
  final String currency;
  final String bankName;
  final bool isBank;
  final void Function(BuildContext) onDelete;
  final String beneficiaryStatus;
  // final String typeText;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: AppColors.red100,
            // foregroundColor: Colors.white,
            icon: Icons.delete_forever_rounded,
            label: "Delete",
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: (5 / Dimensions.designHeight).h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (36 / Dimensions.designWidth).w,
                    height: (36 / Dimensions.designHeight).h,
                    child: Container(
                      width: (35 / Dimensions.designWidth).w,
                      height: (35 / Dimensions.designWidth).w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular((7 / Dimensions.designWidth).w),
                        ),
                        color: const Color.fromRGBO(0, 184, 148, 0.1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: (35 / Dimensions.designWidth).w,
                            height: (10 / Dimensions.designHeight).h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    (7 / Dimensions.designWidth).w),
                                topRight: Radius.circular(
                                    (7 / Dimensions.designWidth).w),
                              ),
                              color: isBank
                                  ? const Color(0XFF1D8296)
                                  : const Color(0XFFF39C12),
                            ),
                            child: Center(
                              child: Text(
                                isBank ? "BANK" : "WALLET",
                                style: TextStyles.primaryBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 7,
                                ),
                              ),
                            ),
                          ),
                          const SizeBox(height: 5),
                          CircleAvatar(
                            radius: ((15 / 2) / Dimensions.designWidth).w,
                            backgroundImage: MemoryImage(
                              base64Decode(flagImgUrl),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizeBox(width: 15),
                  SizedBox(
                    width: 55.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizeBox(height: 3),
                        Text(
                          bankName,
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark50,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizeBox(height: 3),
                        Text(
                          accountNumber,
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark50,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 23.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      // accountNumber,
                      "Currency",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizeBox(height: 7),
                    Text(
                      currency,
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (12 / Dimensions.designWidth).w,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizeBox(height: 7),
                    Text(
                      beneficiaryStatus,
                      style: TextStyles.primaryMedium.copyWith(
                        color: beneficiaryStatus == "Pending"
                            ? AppColors.orange100
                            : beneficiaryStatus == "Approved"
                                ? AppColors.green100
                                : AppColors.red100,
                        fontSize: (12 / Dimensions.designWidth).w,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizeBox(width: 2.w),
            ],
          ),
        ),
      ),
    );
  }
}
