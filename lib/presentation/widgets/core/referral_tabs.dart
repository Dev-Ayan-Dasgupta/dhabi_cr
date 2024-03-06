import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/referral_columns.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ReferralTabs extends StatelessWidget {
  const ReferralTabs({
    Key? key,
    required this.onTap,
    // required this.inviteCount,
    required this.availableInvite,
    required this.totalSuccess,
  }) : super(key: key);

  final VoidCallback onTap;
  final int availableInvite;
  final int totalSuccess;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (7 / Dimensions.designWidth).w,
          vertical: (24 / Dimensions.designHeight).h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          color: Colors.white,
          boxShadow: [BoxShadows.primary],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReferralColumns(
                title: "Available Invite",
                count: availableInvite,
                isSelected: false,
              ),
              const SizeBox(width: 30),
              const VerticalDivider(
                thickness: 0.5,
                width: 0.5,
                color: AppColors.dark50,
              ),
              const SizeBox(width: 30),
              ReferralColumns(
                title: "Total Invitations Success",
                count: totalSuccess,
                isSelected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
