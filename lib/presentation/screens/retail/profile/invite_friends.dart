import 'package:dialup_mobile_app/presentation/widgets/core/appBar/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invite your friends",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(ImageConstants.inviteFriendsCenter),
                        const SizeBox(height: 10),
                        Text(
                          "Congratulations!",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.black,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 20),
                        Text(
                          "You can now extend invitations to your friends.\nYour friends are required to\ncomplete the onboarding process within the\nnext 45 days.",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark50,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Invite details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  ReferralTabs(
                    onTap: () {
                      // Navigator.pushNamed(context,
                      //     Routes.referralDetails);
                    },
                    availableInvite: 0,
                    totalSuccess: 3,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(onTap: () {}, text: "Invite Friends"),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
