import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/invitation/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';

class PopulateInviteDetails {
  static String mobileNumber = "";
  static String addressLine1 = "";
  static String addressLine2 = "";
  static String city = "";
  static String state = "";
  static String postalCode = "";
  static String sourceOfIncome = "";
  static String incomeRange = "";

  static Future<void> populateInviteDetails(
      BuildContext context, String invitationCode) async {
    log("getInviteDetailsResponse -> ${{
      "invitationCode": invitationCode,
    }}");
    var getInviteDetailsResponse =
        await MapInvitationDetails.mapInvitationDetails(
      {
        "invitationCode": invitationCode,
      },
      token ?? "",
    );
    log("getInviteDetailsResponse -> $getInviteDetailsResponse");
    if (getInviteDetailsResponse["success"]) {
      mobileNumber = getInviteDetailsResponse["mobileNumber"];
      await storage.write(key: "mobileNumber", value: mobileNumber);
      storageMobileNumber = await storage.read(key: "mobileNumber");

      addressLine1 = getInviteDetailsResponse["addressLine1"];
      await storage.write(key: "addressLine1", value: addressLine1);
      storageAddressLine1 = await storage.read(key: "addressLine1");

      addressLine2 = getInviteDetailsResponse["addressLine2"];
      await storage.write(key: "addressLine2", value: addressLine2);
      storageAddressLine2 = await storage.read(key: "addressLine2");

      city = getInviteDetailsResponse["city"];
      await storage.write(key: "addressCity", value: city);
      storageAddressCity = await storage.read(key: "addressCity");

      state = getInviteDetailsResponse["state"];
      await storage.write(key: "addressState", value: state);
      storageAddressState = await storage.read(key: "addressState");

      postalCode = getInviteDetailsResponse["postalCode"];
      await storage.write(key: "poBox", value: postalCode);
      storageAddressPoBox = await storage.read(key: "poBox");

      sourceOfIncome = getInviteDetailsResponse["sourceOfIncome"];
      if (sourceOfIncome.isNotEmpty) {
        await storage.write(key: "incomeSource", value: sourceOfIncome);
        storageIncomeSource = await storage.read(key: "incomeSource");
      }

      incomeRange = getInviteDetailsResponse["incomeRange"];
      if (incomeRange.isNotEmpty) {
        await storage.write(key: "incomeRange", value: incomeRange);
        storageIncomeLevel = await storage.read(key: "incomeRange");
      }
    } else {
      if (context.mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialog(
              svgAssetPath: ImageConstants.warning,
              title: "Sorry",
              message:
                  "There was an error getting the invitation details, please try again later.",
              actionWidget: GradientButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: "Okay",
              ),
            );
          },
        );
      }
    }
  }
}
