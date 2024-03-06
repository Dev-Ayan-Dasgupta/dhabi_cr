import 'dart:developer';

import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/data/repositories/invitation/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class AskReferralCode extends StatefulWidget {
  const AskReferralCode({super.key});

  @override
  State<AskReferralCode> createState() => _AskReferralCodeState();
}

String referralCode = "";

class _AskReferralCodeState extends State<AskReferralCode> {
  final TextEditingController _referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (16 / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter referral code"),
            const SizeBox(height: 10),
            CustomTextField(
                controller: _referralController, onChanged: (p0) {}),
            const SizeBox(height: 40),
            SolidButton(
              color: Colors.white,
              fontColor: AppColors.primary,
              borderColor: AppColors.primary,
              onTap: () async {
                // ! Get Inv Email
                log("getInvEmail Req -> ${{
                  "invitationCode": _referralController.text
                }}");
                var getInvEmailRes =
                    await MapInvitationEmail.mapInvitationEmail(
                        {"invitationCode": _referralController.text},
                        token ?? "");
                log("getInvEmailRes -> $getInvEmailRes");

                if (getInvEmailRes["success"]) {
                  if (getInvEmailRes["emailID"] != null) {
                    // ! Send Email OTP
                    log("sendEmailOtp Req -> ${{
                      "emailID": getInvEmailRes["emailID"]
                    }}");
                    var sendEmailOtpRes = await MapSendEmailOtp.mapSendEmailOtp(
                        {"emailID": getInvEmailRes["emailID"]});
                    log("Send Email OTP Response -> $sendEmailOtpRes");
                    if (sendEmailOtpRes["success"]) {
                      referralCode = _referralController.text;
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          Routes.otp,
                          arguments: OTPArgumentModel(
                            emailOrPhone: getInvEmailRes["emailID"],
                            isReferral: true,
                            isEmail: true,
                            isBusiness: false,
                            isInitial: false,
                            isLogin: true,
                            isEmailIdUpdate: false,
                            isMobileUpdate: false,
                            isReKyc: false,
                            userTypeId: storageUserTypeId ?? 1,
                            companyId: storageCompanyId ?? 0,
                          ).toMap(),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        Routes.registration,
                        arguments: RegistrationArgumentModel(
                          isInitial: true,
                          isUpdateCorpEmail: false,
                        ).toMap(),
                      );
                    }
                  }
                } else {}
              },
              text: "Proceed",
            ),
            const SizeBox(height: 10),
            GradientButton(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.registration,
                  arguments: RegistrationArgumentModel(
                    isInitial: true,
                    isUpdateCorpEmail: false,
                  ).toMap(),
                );
              },
              text: "No Referral Code",
            ),
          ],
        ),
      ),
    );
  }
}
