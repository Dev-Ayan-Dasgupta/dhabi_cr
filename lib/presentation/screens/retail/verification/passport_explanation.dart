// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/long_to_short_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:intl/intl.dart';

class PassportExplanationScreen extends StatefulWidget {
  const PassportExplanationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<PassportExplanationScreen> createState() =>
      _PassportExplanationScreenState();
}

class _PassportExplanationScreenState extends State<PassportExplanationScreen> {
  regula.MatchFacesImage image1 = regula.MatchFacesImage();

  Image img1 = Image.asset(ImageConstants.passport);

  bool isScanning = false;

  // int i = 5;

  bool isDialogOpen = false;

  late VerificationInitializationArgumentModel passportReKycArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    // initPlatformState();
    DocumentReader.setConfig({
      "functionality": {
        "showCaptureButton": false,
        "showCaptureButtonDelayFromStart": 2,
        "showCaptureButtonDelayFromDetect": 1,
        "showCloseButton": true,
        "showTorchButton": true,
      },
      "customization": {
        "status": "Searching for document",
        "showBackgroundMask": true,
        "backgroundMaskAlpha": 0.6,
      },
      "processParams": {
        // "logs": true,
        "dateFormat": "dd/MM/yyyy",
        "scenario": ScenarioIdentifier.SCENARIO_MRZ_AND_LOCATE,
        "timeout": 20.0,
        "timeoutFromFirstDetect": 5.0,
        "timeoutFromFirstDocType": 3.0,
        "multipageProcessing": false,
        "licenseUpdate": true,
        "debugSaveLogs": true,
        "debugSaveCroppedImages": true,
        "debugSaveRFIDSession": true,
      }
    });
    const EventChannel('flutter_document_reader_api/event/completion')
        .receiveBroadcastStream()
        .listen(
          (jsonString) => handleCompletion(
            DocumentReaderCompletion.fromJson(
              json.decode(jsonString),
            )!,
          ),
        );
  }

  void argumentInitialization() {
    passportReKycArgument = VerificationInitializationArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
    log("passportReKycArgument -> ${passportReKycArgument.toMap()}");
  }

  void handleCompletion(DocumentReaderCompletion completion) async {
    if (completion.action == DocReaderAction.COMPLETE) {
      DocumentReaderResults? results = completion.results;

      String? firstName =
          await results?.textFieldValueByType(EVisualFieldType.FT_GIVEN_NAMES);

      String? surname =
          await results?.textFieldValueByType(EVisualFieldType.FT_SURNAME);
      // fullName = await results
      //     ?.textFieldValueByType(EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES);
      fullName = "$firstName $surname";
      await storage.write(key: "fullName", value: fullName);
      storageFullName = await storage.read(key: "fullName");
      log("storageFullName -> $storageFullName");

      String? tempPassportNumber =
          await results?.textFieldValueByType(EVisualFieldType.FT_MRZ_STRINGS);

      passportNumber =
          // tempPassportNumber;
          tempPassportNumber?.split("\n").last.split('<').first;
      log("passportNumber -> $passportNumber");

      // passportNumber = await results
      //     ?.textFieldValueByType(EVisualFieldType.FT_PASSPORT_NUMBER);
      await storage.write(key: "passportNumber", value: passportNumber);
      storagePassportNumber = await storage.read(key: "passportNumber");

      log("storagePassportNumber -> $storagePassportNumber");

      nationality = await results?.textFieldValueByTypeLcid(
          EVisualFieldType.FT_NATIONALITY, LCID.LATIN);

      await storage.write(key: "nationality", value: nationality);
      storageNationality = await storage.read(key: "nationality");
      log("storageNationality -> $storageNationality");

      String? tempNationalityCode = await results
          ?.textFieldValueByType(EVisualFieldType.FT_NATIONALITY_CODE);
      nationalityCode =
          LongToShortCode.longToShortCode(tempNationalityCode ?? "");
      await storage.write(key: "nationalityCode", value: nationalityCode);
      storageNationalityCode = await storage.read(key: "nationalityCode");
      log("storageNationalityCode -> $storageNationalityCode");

      String? tempIssuingStateCode = await results
          ?.textFieldValueByType(EVisualFieldType.FT_ISSUING_STATE_CODE);
      issuingStateCode = LongToShortCode.longToShortCode(tempIssuingStateCode!);
      log("issuingState -> $issuingStateCode");
      await storage.write(key: "issuingStateCode", value: issuingStateCode);
      storageIssuingStateCode = await storage.read(key: "issuingStateCode");
      log("storageIssuingStateCode -> $storageIssuingStateCode");

      String? issuingPlace = await results
          ?.textFieldValueByType(EVisualFieldType.FT_PLACE_OF_ISSUE);
      log("issuingPlace -> $issuingPlace");

      expiryDate = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_EXPIRY);
      await storage.write(key: "expiryDate", value: expiryDate);
      storageExpiryDate = await storage.read(key: "expiryDate");
      log("storageExpiryDate -> $storageExpiryDate");

      dob = await results
          ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_BIRTH);
      await storage.write(key: "dob", value: dob);
      storageDob = await storage.read(key: "dob");
      log("storageDob -> $storageDob");

      gender = await results?.textFieldValueByType(EVisualFieldType.FT_SEX);
      await storage.write(key: "gender", value: gender);
      storageGender = await storage.read(key: "gender");
      log("storageGender -> $storageGender");

      Uri? photoUri =
          await results?.graphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);
      photo = photoUri?.path;
      log("photo -> $photo");

      if (photo != null) {
        photo = cleanupBase64Image(photo);
        log("photoString before -> $photo");
        image1.bitmap = base64Encode(base64Decode(photo!.replaceAll("\n", "")));
        image1.imageType = regula.ImageType.PRINTED;
        img1 = Image.memory(base64Decode(photo!.replaceAll("\n", "")));

        log("User photo Size before compress -> ${base64Decode(photo!.replaceAll("\n", "")).lengthInBytes / 1024} KB");
        var compressedPhoto = await FlutterImageCompress.compressWithList(
          base64Decode(photo!.replaceAll("\n", "")),
          quality: 30,
        );
        photo = base64Encode(compressedPhoto);

        log("User photo Size after compress -> ${compressedPhoto.lengthInBytes / 1024} KB");
        img1 = Image.memory(compressedPhoto);

        log("photoString after -> $photo");
        await storage.write(key: "photo", value: photo);
        storagePhoto = await storage.read(key: "photo");
        log("storagePhoto -> $storagePhoto");
      }

      Uri? docPhotoUri = await results
          ?.graphicFieldImageByType(EGraphicFieldType.GF_DOCUMENT_IMAGE);
      docPhoto = docPhotoUri?.path;
      docPhoto = cleanupBase64Image(docPhoto);
      log("docPhoto -> $docPhoto");
      var compressedDocPhoto = await FlutterImageCompress.compressWithList(
        base64Decode(docPhoto ?? ""),
        quality: 30,
      );
      docPhoto = base64Encode(compressedDocPhoto);

      log("Size after compress docphoto -> ${compressedDocPhoto.lengthInBytes / 1024} KB");

      await storage.write(key: "docPhoto", value: docPhoto);
      storageDocPhoto = await storage.read(key: "docPhoto");
      log("storageDocPhoto -> $storageDocPhoto");

      log("Doc Expired check -> ${DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000"))).difference(DateTime.now()).inDays}");
      log("Age check -> ${DateTime.now().difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000")))).inDays}");

      if (passportNumber != null &&
          storageNationalityCode != null &&
          storageFullName != null &&
          storageNationality != null &&
          storageExpiryDate != null &&
          storageDob != null &&
          storageGender != null &&
          storagePhoto != null &&
          storageDocPhoto != null &&
          storageIssuingStateCode != null) {
        var result = await MapIfPassportExists.mapIfPassportExists(
          {
            "passportNumber": passportNumber,
          },
          token ?? "",
        );
        log("If Passport Exists API response -> $result");

        // ? Check for expired
        if (DateTime.parse(DateFormat('yyyy-MM-dd').format(
                    DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000")))
                .difference(DateTime.now())
                .inDays <
            0) {
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              Routes.errorSuccessScreen,
              arguments: ErrorArgumentModel(
                hasSecondaryButton: false,
                iconPath: ImageConstants.errorOutlined,
                title: messages[82]["messageText"],
                message: messages[31]["messageText"],
                buttonText: "Go Home",
                // labels[1]["labelText"],
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.retailOnboardingStatus,
                    (route) => false,
                    arguments: OnboardingStatusArgumentModel(
                      stepsCompleted: 1,
                      isFatca: false,
                      isPassport: false,
                      isRetail: true,
                    ).toMap(),
                  );
                },
                buttonTextSecondary: "",
                onTapSecondary: () {},
              ).toMap(),
            );
          }
        }

        // ? Check for age
        else if (DateTime.now()
                .difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(
                    DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000"))))
                .inDays <
            ((18 * 365) + 4)) {
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              Routes.errorSuccessScreen,
              arguments: ErrorArgumentModel(
                hasSecondaryButton: false,
                iconPath: ImageConstants.errorOutlined,
                title: messages[80]["messageText"],
                message: messages[33]["messageText"],
                buttonText: "Go Home",
                // labels[1]["labelText"],
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.retailOnboardingStatus,
                    (route) => false,
                    arguments: OnboardingStatusArgumentModel(
                      stepsCompleted: 1,
                      isFatca: false,
                      isPassport: false,
                      isRetail: true,
                    ).toMap(),
                  );
                },
                buttonTextSecondary: "",
                onTapSecondary: () {},
              ).toMap(),
            );
          }
        }

        // ? Check for previous existence
        else if (!(passportReKycArgument.isReKyc)) {
          if (result["exists"]) {
            if (context.mounted) {
              Navigator.pushNamed(context, Routes.errorSuccessScreen,
                  arguments: ErrorArgumentModel(
                    hasSecondaryButton: false,
                    iconPath: ImageConstants.warningRed,
                    title: messages[76]["messageText"],
                    message: messages[21]["messageText"],
                    buttonText: labels[205]["labelText"],
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.loginUserId,
                        (route) => false,
                        arguments: OnboardingStatusArgumentModel(
                          stepsCompleted: 1,
                          isFatca: false,
                          isPassport: false,
                          isRetail: true,
                        ).toMap(),
                      );
                    },
                    buttonTextSecondary: "",
                    onTapSecondary: () {},
                  ).toMap());
            }
          } else {
            await storage.write(key: "isEid", value: false.toString());
            // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
            storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
            if (!(passportReKycArgument.isReKyc)) {
              await storage.write(key: "stepsCompleted", value: 3.toString());
              storageStepsCompleted =
                  int.parse(await storage.read(key: "stepsCompleted") ?? "0");
            }

            if (context.mounted) {
              Navigator.pushNamed(
                context,
                Routes.scannedDetails,
                arguments: ScannedDetailsArgumentModel(
                  isEID: false,
                  fullName: fullName,
                  idNumber: passportNumber,
                  nationality: nationality,
                  nationalityCode: nationalityCode,
                  expiryDate: expiryDate,
                  dob: dob,
                  gender: gender,
                  photo: photo,
                  docPhoto: docPhoto,
                  isReKyc: passportReKycArgument.isReKyc,
                ).toMap(),
              );
            }
          }
        } else {
          await storage.write(key: "isEid", value: false.toString());
          // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
          storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
          if (!(passportReKycArgument.isReKyc)) {
            await storage.write(key: "stepsCompleted", value: 3.toString());
            storageStepsCompleted =
                int.parse(await storage.read(key: "stepsCompleted") ?? "0");
          }

          if (context.mounted) {
            Navigator.pushNamed(
              context,
              Routes.scannedDetails,
              arguments: ScannedDetailsArgumentModel(
                isEID: false,
                fullName: fullName,
                idNumber: passportNumber,
                nationality: nationality,
                nationalityCode: nationalityCode,
                expiryDate: expiryDate,
                dob: dob,
                gender: gender,
                photo: photo,
                docPhoto: docPhoto,
                isReKyc: passportReKycArgument.isReKyc,
              ).toMap(),
            );
          }
        }
      } else {
        if (context.mounted) {
          promptScanError();
        }
      }
    } else if (completion.action == DocReaderAction.TIMEOUT) {
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          Routes.errorSuccessScreen,
          arguments: ErrorArgumentModel(
            hasSecondaryButton: false,
            iconPath: ImageConstants.warningRed,
            title: messages[73]["messageText"],
            message: "Your time has run out. Please try again.",
            buttonText: labels[88]["labelText"],
            onTap: () {
              Navigator.pop(context);
            },
            buttonTextSecondary: "",
            onTapSecondary: () {},
          ).toMap(),
        );
      }
    } else if (completion.action == DocReaderAction.ERROR) {
      if (context.mounted) {
        promptScanError();
      }
    } else if (completion.action == DocReaderAction.CANCEL ||
        completion.action == DocReaderAction.MORE_PAGES_AVAILABLE ||
        completion.action == DocReaderAction.NOTIFICATION ||
        completion.action == DocReaderAction.PROCESS ||
        completion.action == DocReaderAction.PROCESSING_ON_SERVICE ||
        completion.action == DocReaderAction.PROCESS_IR_FRAME ||
        completion.action == DocReaderAction.PROCESS_WHITE_FLASHLIGHT ||
        completion.action == DocReaderAction.PROCESS_WHITE_UV_IMAGES) {
      // ! Don't do anthing for now
    } else {
      if (context.mounted) {
        promptScanError();
      }
    }
  }

  String? cleanupBase64Image(String? base64Image) {
    base64Image = base64Image?.replaceAll("image/png;", "");
    base64Image = base64Image?.replaceAll("base64", "");
    base64Image = base64Image?.replaceAll(",;", "");
    base64Image = base64Image?.replaceAll(",", "");
    base64Image = base64Image?.replaceAll("\n", "");

    return base64Image;
  }

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
                    labels[252]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Scan the first page of your passport.",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (280 / Dimensions.designWidth).w,
                      height: (384 / Dimensions.designHeight).h,
                      child: Image.asset(ImageConstants.passport),
                    ),
                  ),
                  const SizeBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      labels[254]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: () {
                    setState(() {
                      isDialogOpen = false;
                    });

                    if (!isScanning) {
                      final ShowButtonBloc showButtonBloc =
                          context.read<ShowButtonBloc>();
                      isScanning = true;
                      showButtonBloc.add(ShowButtonEvent(show: isScanning));
                      promptUser();
                      isScanning = false;
                      showButtonBloc.add(ShowButtonEvent(show: isScanning));
                    }
                  },
                  text: labels[231]["labelText"],
                  auxWidget: isScanning ? const LoaderRow() : const SizeBox(),
                ),
                const SizeBox(height: 15),
                SolidButton(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.retailOnboardingStatus,
                      arguments: OnboardingStatusArgumentModel(
                        stepsCompleted: 1,
                        isFatca: false,
                        isPassport: false,
                        isRetail: true,
                      ).toMap(),
                    );
                  },
                  text: labels[235]["labelText"],
                  color: AppColors.primaryBright17,
                  fontColor: AppColors.primary,
                ),
                const SizeBox(height: PaddingConstants.bottomPadding),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void promptScanError() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message: messages[30]["messageText"],
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[233]["labelText"],
          message: labels[234]["labelText"],
          auxWidget: GradientButton(
            onTap: () {
              // Navigator.pushNamed(context, Routes.eidDetails);
              isEidChosen = false;
              DocumentReader.showScanner();
              Navigator.pop(context);
            },
            text: "Allow Access",
          ),
          actionWidget: SolidButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[235]["labelText"],
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
          ),
        );
      },
    );
  }
}
