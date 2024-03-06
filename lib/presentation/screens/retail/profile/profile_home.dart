// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/business/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/profile/edit_profile_photo.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  String? version;

  bool isUploading = false;

  bool hasProfilePicUpdated = false;

  bool isLoggingOut = false;

  late ProfileArgumentModel profileArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPackageInfo();
      setState(() {});
    });
  }

  void argumentInitialization() {
    profileArgument =
        ProfileArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasProfilePicUpdated) {
          if (storageUserTypeId == 1) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.retailDashboard,
              (route) => false,
              arguments: RetailDashboardArgumentModel(
                imgUrl: "",
                name: profileName ?? "",
                isFirst: storageIsFirstLogin == true ? false : true,
              ).toMap(),
            );
          } else {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.businessDashboard,
                (route) => false,
                arguments: RetailDashboardArgumentModel(
                  imgUrl: storageProfilePhotoBase64 ?? "",
                  name: profileName ?? "",
                  isFirst: storageIsFirstLogin == true ? false : true,
                ).toMap(),
              );
            }
          }
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              if (hasProfilePicUpdated) {
                if (storageUserTypeId == 1) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.retailDashboard,
                    (route) => false,
                    arguments: RetailDashboardArgumentModel(
                      imgUrl: "",
                      name: profileName ?? "",
                      isFirst: storageIsFirstLogin == true ? false : true,
                    ).toMap(),
                  );
                } else {
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.businessDashboard,
                      (route) => false,
                      arguments: RetailDashboardArgumentModel(
                        imgUrl: storageProfilePhotoBase64 ?? "",
                        name: profileName ?? "",
                        isFirst: storageIsFirstLogin == true ? false : true,
                      ).toMap(),
                    );
                  }
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // const SizeBox(height: 10),
                        EditProfilePhoto(
                          isMemoryImage: profilePhotoBase64 != null,
                          bytes: base64Decode(profilePhotoBase64 ?? ""),
                          onTap: showImageUploadOptions,
                        ),
                        const SizeBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  profileName ?? "",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (20 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const SizeBox(height: 30),
                                TopicTile(
                                  color: const Color(0XFFFAFAFA),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.profile,
                                      arguments: ProfileArgumentModel(
                                        isRetail: profileArgument.isRetail,
                                      ).toMap(),
                                    );
                                  },
                                  iconPath: ImageConstants.settingsAccountBox,
                                  text: labels[12]["labelText"],
                                ),
                                const SizeBox(height: 10),
                                TopicTile(
                                  color: const Color(0XFFFAFAFA),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.security,
                                      arguments:
                                          ProfileUpdatePasswordArgumentModel(
                                        isRetail: profileArgument.isRetail,
                                        isEmailChange: false,
                                        isMobileChange: false,
                                        isPasswordChange: true,
                                      ).toMap(),
                                    );
                                  },
                                  iconPath: ImageConstants.security,
                                  text: labels[13]["labelText"],
                                ),
                                const SizeBox(height: 10),
                                TopicTile(
                                  color: const Color(0XFFFAFAFA),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.requestType);
                                  },
                                  iconPath: ImageConstants.handshake,
                                  text: labels[14]["labelText"],
                                ),
                                const SizeBox(height: 10),
                                TopicTile(
                                  color: const Color(0XFFFAFAFA),
                                  onTap: promptUserContactUs,
                                  iconPath: ImageConstants.atTheRate,
                                  text: labels[15]["labelText"],
                                ),
                                const SizeBox(height: 10),
                                TopicTile(
                                  color: const Color(0XFFFAFAFA),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.termsAndConditions);
                                  },
                                  iconPath: ImageConstants.termsAndConditions,
                                  text: "Terms & Conditions",
                                ),
                                const SizeBox(height: 10),
                                TopicTile(
                                  color: const Color(0XFFFAFAFA),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.privacyStatement);
                                  },
                                  iconPath: ImageConstants.privacyPolicy,
                                  text: "Privacy Policy",
                                ),
                                const SizeBox(height: 10),
                                TopicTile(
                                  color: const Color(0XFFFAFAFA),
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.faq);
                                  },
                                  iconPath: ImageConstants.faq,
                                  text: labels[16]["labelText"],
                                ),
                                SizeBox(
                                  height: storageHasSingleCif == true ? 0 : 10,
                                ),
                                Ternary(
                                  condition: storageHasSingleCif == true,
                                  truthy: const SizeBox(),
                                  falsy: TopicTile(
                                    color: const Color(0XFFFAFAFA),
                                    onTap: () async {
                                      var getCustomerDetailsResponse =
                                          await MapCustomerDetails
                                              .mapCustomerDetails(token ?? "");
                                      log("Get Customer Details API response -> $getCustomerDetailsResponse");

                                      List cifDetails =
                                          getCustomerDetailsResponse[
                                              "cifDetails"];

                                      if (cifDetails.length > 1) {
                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.selectAccount,
                                            arguments:
                                                SelectAccountArgumentModel(
                                              emailId: storageEmail ?? "",
                                              cifDetails: cifDetails,
                                              isPwChange: false,
                                              isLogin: true,
                                              isSwitching: true,
                                              isIncompleteOnboarding: false,
                                            ).toMap(),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialog(
                                                svgAssetPath:
                                                    ImageConstants.warning,
                                                title: "No Other Acount",
                                                message:
                                                    "You have only one registered account.",
                                                actionWidget: GradientButton(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    text: labels[347]
                                                        ["labelText"]),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    iconPath: ImageConstants.rotate,
                                    text: labels[17]["labelText"],
                                  ),
                                ),
                                const SizeBox(height: 10),
                                TopicTile(
                                  tappedColor: AppColors.red100,
                                  color: const Color(0XFFFAFAFA),
                                  onTap: promptUserLogout,
                                  iconPath: ImageConstants.logout,
                                  text: labels[18]["labelText"],
                                  fontColor: AppColors.red100,
                                  iconColor: AppColors.red100,
                                  highlightColor:
                                      const Color.fromRGBO(201, 69, 64, 0.1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizeBox(height: 20),
                      Text(
                        "App Version $version",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Ternary(
              condition: isUploading,
              truthy: SpinKitFadingCircle(
                color: AppColors.primary,
                size: (50 / Dimensions.designWidth).w,
              ),
              falsy: const SizeBox(),
            ),
          ],
        ),
      ),
    );
  }

  void promptUserContactUs() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.sentimentSatisfied,
          title: "Hey, there!",
          message: "${labels[62]["labelText"]}\n${labels[63]["labelText"]}",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Back",
          ),
        );
      },
    );
  }

  void promptUserLogout() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[250]["labelText"],
          message: "If you log out you would need to re-login again",
          auxWidget: BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return GradientButton(
                onTap: () async {
                  if (!isLoggingOut) {
                    final ShowButtonBloc showButtonBloc =
                        context.read<ShowButtonBloc>();
                    isLoggingOut = true;
                    showButtonBloc.add(ShowButtonEvent(show: isLoggingOut));
                    fdSeedAccounts.clear();
                    dhabiSeedAccounts.clear();
                    domesticSeedAccounts.clear();
                    internalSeedAccounts.clear();
                    foreignSeedAccounts.clear();
                    canTransferDomesticFund = true;
                    canTransferInternationalFund = true;
                    canTransferInternalFund = true;
                    canTransferDhabiFund = true;

                    canCreateFD = true;

                    canCreateSavingsAccount = true;
                    canCreateCurrentAccount = true;

                    canChangeAddress = true;
                    canChangeMobileNumber = true;
                    canChangeEmailId = true;

                    canUpdateKYC = true;
                    canCloseAccount = true;
                    canRequestChequeBook = true;
                    canRequestCertificate = true;
                    canRequestAccountStatement = true;
                    canRequestCard = true;
                    // statementList.clear();
                    // fdStatementList.clear();
                    // displayStatementList.clear();
                    // displayFdStatementList.clear();
                    await storage.write(
                        key: "loggedOut", value: true.toString());
                    storageLoggedOut =
                        await storage.read(key: "loggedOut") == "true";

                    await storage.delete(key: "hasFirstLoggedIn");
                    await storage.delete(key: "isFirstLogin");
                    await storage.delete(key: "userId");
                    await storage.delete(key: "password");
                    await storage.delete(key: "emailAddress");
                    await storage.delete(key: "userTypeId");
                    await storage.delete(key: "companyId");
                    // await storage.delete(key: "persistBiometric");
                    await storage.delete(key: "stepsCompleted");
                    await storage.delete(key: "isEid");
                    await storage.delete(key: "fullName");
                    await storage.delete(key: "eiDNumber");
                    await storage.delete(key: "passportNumber");
                    await storage.delete(key: "nationality");
                    await storage.delete(key: "nationalityCode");
                    await storage.delete(key: "issuingStateCode");
                    await storage.delete(key: "expiryDate");
                    await storage.delete(key: "dob");
                    await storage.delete(key: "gender");
                    await storage.delete(key: "photo");
                    await storage.delete(key: "docPhoto");
                    await storage.delete(key: "selfiePhoto");
                    await storage.delete(key: "photoMatchScore");
                    await storage.delete(key: "addressCountry");
                    await storage.delete(key: "poBox");
                    await storage.delete(key: "incomeSource");
                    await storage.delete(key: "isUSFatca");
                    await storage.delete(key: "taxCountry");
                    await storage.delete(key: "isTinYes");
                    await storage.delete(key: "crsTin");
                    await storage.delete(key: "noTinReason");
                    await storage.delete(key: "accountType");
                    await storage.delete(key: "cif");
                    await storage.delete(key: "isCompany");
                    await storage.delete(key: "isCompanyRegistered");
                    await storage.delete(key: "retailLoggedIn");
                    await storage.delete(key: "customerName");
                    await storage.delete(key: "chosenAccount");

                    // var logoutRes = await
                    MapLogout.mapLogout(token ?? "");
                    // log("logoutRes -> $logoutRes");

                    // if (logoutRes["success"]) {
                    // } else {}

                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.onboarding,
                        (routes) => false,
                        arguments: OnboardingArgumentModel(
                          isInitial: true,
                        ).toMap(),
                      );
                    }
                    isLoggingOut = false;
                    showButtonBloc.add(ShowButtonEvent(show: isLoggingOut));
                  }
                },
                text: "Yes, I am sure",
                auxWidget: isLoggingOut ? const LoaderRow() : const SizeBox(),
              );
            },
          ),
          actionWidget: SolidButton(
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[166]["labelText"],
          ),
        );
      },
    );
  }

  void showImageUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: (127 / Dimensions.designHeight).h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular((10 / Dimensions.designWidth).w),
              topRight: Radius.circular((10 / Dimensions.designWidth).w),
            ),
          ),
          child: Column(
            children: [
              const SizeBox(height: 10),
              ListTile(
                dense: true,
                onTap: () {
                  uploadImage(ImageSource.camera);
                },
                leading: Container(
                  width: (30 / Dimensions.designWidth).w,
                  height: (30 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: AppColors.primary,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: (15 / Dimensions.designWidth).w,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  "Camera",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ),
              ListTile(
                dense: true,
                onTap: () async {
                  uploadImage(ImageSource.gallery);
                },
                leading: Container(
                  width: (30 / Dimensions.designWidth).w,
                  height: (30 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: AppColors.primary,
                    ),
                  ),
                  child: Icon(
                    Icons.collections_rounded,
                    size: (15 / Dimensions.designWidth).w,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  "Gallery",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void promptUploadPhotoError() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Image Upload Failed",
          message: "Your attempt to upload your profile photo failed.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[347]["labelText"],
          ),
        );
      },
    );
  }

  void uploadImage(ImageSource source) async {
    Navigator.pop(context);
    isUploading = true;
    setState(() {});
    XFile? pickedImageFile = await ImagePicker().pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 40,
    );

    if (pickedImageFile != null) {
      log("Picked photo size -> ${((await pickedImageFile.readAsBytes()).lengthInBytes) / 1024} KB");
      CroppedFile? croppedImageFile = await ImageCropper().cropImage(
          sourcePath: pickedImageFile.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressQuality: 40);

      if (croppedImageFile != null) {
        log("Cropped photo size -> ${((await croppedImageFile.readAsBytes()).lengthInBytes) / 1024} KB");
        String photoBase64 = base64Encode(await croppedImageFile.readAsBytes());

        var compressedphotoBase64 = await FlutterImageCompress.compressWithList(
          base64Decode(photoBase64),
          quality: 25,
        );
        photoBase64 = base64Encode(compressedphotoBase64);

        log("Compressed Cropped photo size -> ${((base64Decode(photoBase64).lengthInBytes) / 1024)} KB");

        var uploadPPResult = await MapUploadProfilePhoto.mapUploadProfilePhoto(
          {
            "photoBase64": photoBase64,
          },
          token ?? "",
        );
        log("Upload Profile Photo response -> $uploadPPResult");

        if (uploadPPResult["success"]) {
          var getProfileDataResult =
              await MapProfileData.mapProfileData(token ?? "");
          if (getProfileDataResult["success"]) {
            profilePhotoBase64 = getProfileDataResult["profileImageBase64"];
            await storage.write(
                key: "profilePhotoBase64", value: profilePhotoBase64);
            storageProfilePhotoBase64 =
                await storage.read(key: "profilePhotoBase64");
            hasProfilePicUpdated = true;
          }
        } else {
          promptUploadPhotoError();
        }
        isUploading = false;
        setState(() {});
      } else {
        isUploading = false;
        setState(() {});
      }
    } else {
      isUploading = false;
      setState(() {});
    }
  }
}
