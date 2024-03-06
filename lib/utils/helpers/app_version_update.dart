import 'dart:developer';

import 'package:app_version_update/app_version_update.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';

class AppUpdate {
  static Future<void> showUpdatePopup(BuildContext context) async {
    const appleId =
        '6451184658'; // If this value is null, its packagename will be considered
    const playStoreId =
        'com.dhabi.digital'; // If this value is null, its packagename will be considered
    // const country =
    //     'br'; // If this value is null 'us' will be the default value
    await AppVersionUpdate.checkForUpdates(
      appleId: appleId,
      playStoreId: playStoreId,
      // country: country,
    ).then(
      (data) async {
        log("${data.storeUrl}");
        log("${data.storeVersion}");
        if (data.canUpdate!) {
          //showDialog(... your custom widgets view)
          //or use our widgets
          // AppVersionUpdate.showAlertUpdate
          // AppVersionUpdate.showBottomSheetUpdate
          // AppVersionUpdate.showPageUpdate
          AppVersionUpdate.showAlertUpdate(
            appVersionResult: data,
            context: context,
            title: "New version available",
            content: "Would you like to update your application?",
            cancelButtonText: "Later",
            updateButtonText: "Update",
            cancelTextStyle: TextStyles.primaryMedium.copyWith(
              fontSize: 12,
              color: AppColors.dark50,
            ),
            updateTextStyle: TextStyles.primaryMedium.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
            cancelButtonStyle: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.transparent),
            ),
            updateButtonStyle: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppColors.primary),
            ),
          );
        }
      },
    );
  }
}
