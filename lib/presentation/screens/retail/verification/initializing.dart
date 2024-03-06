// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class VerificationInitializingScreen extends StatefulWidget {
  const VerificationInitializingScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<VerificationInitializingScreen> createState() =>
      _VerificationInitializingScreenState();
}

class _VerificationInitializingScreenState
    extends State<VerificationInitializingScreen> {
  String status = "Downloading Database";

  String progressValue = "0";

  late VerificationInitializationArgumentModel
      verificationInitializationArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    initPlatformState();

    const EventChannel('flutter_document_reader_api/event/database_progress')
        .receiveBroadcastStream()
        .listen(
      (progress) {
        log("DB Progress -> $progress");
        setState(
          () {
            progressValue = progress;
          },
        );
      },
    );
  }

  void argumentInitialization() {
    verificationInitializationArgument =
        VerificationInitializationArgumentModel.fromMap(
            widget.argument as dynamic ?? {});
  }

  Future<void> initPlatformState() async {
    var prepareDatabase = await DocumentReader.prepareDatabase("ARE");
    log("prepareDatabase -> $prepareDatabase");
    setState(() {
      status = "Initializing";
    });
    ByteData byteData = await rootBundle.load("assets/regula.license");
    var documentReaderInitialization = await DocumentReader.initializeReader({
      "license": base64.encode(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)),
      "delayedNNLoad": true,
      "licenseUpdate": true,
    });
    log("documentReaderInitialization -> $documentReaderInitialization");
    setState(() {
      status = "Ready";
    });
    // DocumentReader.setConfig({
    //   "functionality": {
    //     "showCaptureButton": true,
    //     "showCaptureButtonDelayFromStart": 2,
    //     "showCaptureButtonDelayFromDetect": 1,
    //     "showCloseButton": true,
    //     "showTorchButton": true,
    //   },
    //   "customization": {
    //     "status": "Searching for document",
    //     "showBackgroundMask": true,
    //     "backgroundMaskAlpha": 0.6,
    //   },
    //   "processParams": {
    //     "logs": true,
    //     "dateFormat": "dd/MM/yyyy",
    //     "scenario": "MrzOrOcr",
    //     "timeout": 30.0,
    //     "timeoutFromFirstDetect": 30.0,
    //     "timeoutFromFirstDocType": 30.0,
    //     "multipageProcessing": true
    //   }
    // });

    if (context.mounted) {
      if (storageStepsCompleted == 2 ||
          verificationInitializationArgument.isReKyc == true) {
        Navigator.pushReplacementNamed(
          context,
          Routes.eidExplanation,
          arguments: VerificationInitializationArgumentModel(
            isReKyc: verificationInitializationArgument.isReKyc,
          ).toMap(),
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          Routes.scannedDetails,
          arguments: ScannedDetailsArgumentModel(
            isEID: storageIsEid! ? true : false,
            fullName: storageFullName,
            idNumber: storageIsEid! ? storageEidNumber : storagePassportNumber,
            nationality: storageNationality,
            nationalityCode: storageNationalityCode,
            expiryDate: storageExpiryDate,
            dob: storageDob,
            gender: storageGender,
            photo: storagePhoto,
            docPhoto: storageDocPhoto,
            isReKyc: verificationInitializationArgument.isReKyc,
          ).toMap(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SpinKitFadingCircle(
            //   color: AppColors.primary,
            //   size: (50 / Dimensions.designWidth).w,
            // ),
            CircularPercentIndicator(
              radius: (50 / Dimensions.designWidth).w,
              percent: double.parse(progressValue) / 100,
              lineWidth: 5,
              backgroundColor: AppColors.dark30,
              progressColor: AppColors.primary,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text(
                "$progressValue%",
                style: TextStyles.primaryMedium.copyWith(
                  fontSize: (14 / Dimensions.designWidth).w,
                  color: AppColors.dark80,
                ),
              ),
            ),
            const SizeBox(height: 20),
            Text(
              double.parse(progressValue) < 25
                  ? "Hang tight..."
                  : double.parse(progressValue) < 50
                      ? "Just a few seconds..."
                      : double.parse(progressValue) < 75
                          ? "Getting things ready..."
                          : "Almost there...",
              style: TextStyles.primaryMedium.copyWith(
                fontSize: (14 / Dimensions.designWidth).w,
                color: AppColors.dark80,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "Initialization Status: ",
            //       style: TextStyles.primaryBold.copyWith(color: Colors.black),
            //     ),
            //     Text(
            //       status,
            //       style: TextStyles.primaryMedium.copyWith(color: Colors.black),
            //     ),
            //   ],
            // ),
            // Text("Database download progress -> $progressValue%"),
          ],
        ),
      ),
    );
  }
}
