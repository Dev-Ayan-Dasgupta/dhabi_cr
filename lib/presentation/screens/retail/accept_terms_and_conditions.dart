// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AcceptTermsAndConditionsScreen extends StatefulWidget {
  const AcceptTermsAndConditionsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<AcceptTermsAndConditionsScreen> createState() =>
      _AcceptTermsAndConditionsScreenState();
}

class _AcceptTermsAndConditionsScreenState
    extends State<AcceptTermsAndConditionsScreen> {
  bool isChecked = false;
  final ScrollController _scrollController = ScrollController();
  bool scrollDown = true;

  bool isUploading = false;

  late CreateAccountArgumentModel createAccountArgumentModel;

  @override
  void initState() {
    super.initState();
    createAccountArgumentModel =
        CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients) {
          if (_scrollController.offset >
              (_scrollController.position.maxScrollExtent -
                      _scrollController.position.minScrollExtent) /
                  2) {
            scrollDown = false;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          } else {
            scrollDown = true;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Terms & Conditions",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: 1,
                                itemBuilder: (context, _) {
                                  return SizedBox(
                                    width: 100.w,
                                    child: HtmlWidget(terms),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        BlocBuilder<CheckBoxBloc, CheckBoxState>(
                          builder: (context, state) {
                            if (isChecked) {
                              return InkWell(
                                onTap: () {
                                  isChecked = false;
                                  triggerCheckBoxEvent(isChecked);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      (5 / Dimensions.designWidth).w),
                                  child: SvgPicture.asset(
                                      ImageConstants.checkedBox),
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  isChecked = true;
                                  triggerCheckBoxEvent(isChecked);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      (5 / Dimensions.designWidth).w),
                                  child: SvgPicture.asset(
                                      ImageConstants.uncheckedBox),
                                ),
                              );
                            }
                          },
                        ),
                        const SizeBox(width: 5),
                        Text(
                          "I've read all the terms and conditions",
                          style: TextStyles.primary.copyWith(
                            color: const Color(0XFF414141),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                    const SizeBox(height: 20),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        if (isChecked) {
                          return GradientButton(
                            onTap: () async {
                              if (!isUploading) {
                                log("storageNationalityCode -> $storageNationalityCode");
                                final ShowButtonBloc showButtonBloc =
                                    context.read<ShowButtonBloc>();
                                isUploading = true;
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isUploading));

                                // if (storageIsEid == true) {
                                //   var response =
                                //       await MapUploadEid.mapUploadEid(
                                //     {
                                //       "eidDocumentImage": storageDocPhoto,
                                //       "eidUserPhoto": storagePhoto,
                                //       "selfiePhoto": storageSelfiePhoto,
                                //       "photoMatchScore": storagePhotoMatchScore,
                                //       "eidNumber": storageEidNumber,
                                //       "fullName": storageFullName,
                                //       "dateOfBirth": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd MMMM yyyy')
                                //               .parse(storageDob ??
                                //                   "1 January 1900")),
                                //       "nationalityCountryCode":
                                //           storageNationalityCode,
                                //       "genderId": storageGender == 'M' ? 1 : 2,
                                //       "expiresOn": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd MMMM yyyy')
                                //               .parse(storageExpiryDate ??
                                //                   "1 January 1900")),
                                //       "isReKYC": false
                                //     },
                                //     token ?? "",
                                //   );

                                //   log("UploadEid API response -> $response");
                                // } else {
                                //   var response =
                                //       await MapUploadPassport.mapUploadPassport(
                                //     {
                                //       "passportDocumentImage": storageDocPhoto,
                                //       "passportUserPhoto": storagePhoto,
                                //       "selfiePhoto": storageSelfiePhoto,
                                //       "photoMatchScore": storagePhotoMatchScore,
                                //       "passportNumber": storagePassportNumber,
                                //       "passportIssuingCountryCode":
                                //           storageIssuingStateCode,
                                //       "fullName": storageFullName,
                                //       "dateOfBirth": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd/MM/yyyy')
                                //               .parse(
                                //                   storageDob ?? "00/00/0000")),
                                //       "nationalityCountryCode":
                                //           storageNationalityCode,
                                //       "genderId": storageGender == 'M' ? 1 : 2,
                                //       "expiresOn": DateFormat('yyyy-MM-dd')
                                //           .format(DateFormat('dd/MM/yyyy')
                                //               .parse(storageExpiryDate ??
                                //                   "00/00/0000")),
                                //       "isReKYC": false
                                //     },
                                //     token ?? "",
                                //   );
                                //   log("UploadPassport API response -> $response");
                                // }
                                var createCustomerResult =
                                    await MapCreateCustomer.mapCreateCustomer(
                                        token ?? "");
                                log("createCustomerResult -> $createCustomerResult");

                                if (createCustomerResult["success"]) {
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.pendingStatus,
                                    );
                                    // Navigator.pushNamedAndRemoveUntil(
                                    //   context,
                                    //   Routes.retailDashboard,
                                    //   (route) => false,
                                    //   arguments:
                                    //       RetailDashboardArgumentModel(
                                    //     imgUrl: "",
                                    //     name: storageFullName ?? "",
                                    //     isFirst: false,
                                    //   ).toMap(),
                                    // );
                                  }
                                } else {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomDialog(
                                          svgAssetPath: ImageConstants.warning,
                                          title: "Sorry!",
                                          message: createCustomerResult[
                                                  "message"] ??
                                              "There was an error in creating customer, please try again later.",
                                          actionWidget: GradientButton(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            text: labels[346]["labelText"],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  log("Create Customer API failed -> ${createCustomerResult["message"]}");
                                }

                                isUploading = false;
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isUploading));

                                await storage.write(
                                    key: "stepsCompleted", value: 0.toString());
                                storageStepsCompleted = int.parse(
                                    await storage.read(key: "stepsCompleted") ??
                                        "0");

                                await storage.write(
                                    key: "hasFirstLoggedIn",
                                    value: true.toString());
                                storageHasFirstLoggedIn = (await storage.read(
                                        key: "hasFirstLoggedIn")) ==
                                    "true";

                                profilePhotoBase64 = null;
                                await storage.write(
                                    key: "profilePhotoBase64",
                                    value: profilePhotoBase64);
                                storageProfilePhotoBase64 = await storage.read(
                                    key: "profilePhotoBase64");
                              }
                            },
                            text: "I Agree",
                            auxWidget: isUploading
                                ? const LoaderRow()
                                : const SizeBox(),
                          );
                        } else {
                          return SolidButton(onTap: () {}, text: "I Agree");
                        }
                      },
                    ),
                    SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ],
            ),
            BlocBuilder<ScrollDirectionBloc, ScrollDirectionState>(
              builder: (context, state) {
                return Positioned(
                  right: 0,
                  bottom: (150 / Dimensions.designWidth).w -
                      MediaQuery.of(context).viewPadding.bottom,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      if (!scrollDown) {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                          scrollDown = true;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      } else {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );

                          scrollDown = false;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      }
                    },
                    child: Container(
                      width: (50 / Dimensions.designWidth).w,
                      height: (50 / Dimensions.designWidth).w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadows.primary],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          !scrollDown
                              ? ImageConstants.arrowUpward
                              : ImageConstants.arrowDownward,
                          // : ImageConstants.arrowDownward,
                          width: (16 / Dimensions.designWidth).w,
                          height: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }

  Future<void> getProfileData() async {
    try {
      var getProfileDataResult =
          await MapProfileData.mapProfileData(token ?? "");
      log("getProfileDataResult -> $getProfileDataResult");
      if (getProfileDataResult["success"]) {
        profileName = getProfileDataResult["name"];
        await storage.write(key: "customerName", value: profileName);
        storageCustomerName = await storage.read(key: "customerName");

        profilePhotoBase64 = getProfileDataResult["profileImageBase64"];
        await storage.write(
            key: "profilePhotoBase64", value: profilePhotoBase64);
        storageProfilePhotoBase64 =
            await storage.read(key: "profilePhotoBase64");
        profileDoB = getProfileDataResult["dateOfBirth"];
        profileEmailId = getProfileDataResult["emailID"];
        profileMobileNumber = getProfileDataResult["mobileNumber"];
        profileAddressLine1 = getProfileDataResult["addressLine_1"];
        profileAddressLine2 = getProfileDataResult["addressLine_2"];
        profileCity = getProfileDataResult["city"] ?? "";
        profileState = getProfileDataResult["state"] ?? "";
        profilePinCode = getProfileDataResult["pinCode"];
        profileCountryCode = getProfileDataResult["countryCode"];

        await storage.write(key: "emailAddress", value: profileEmailId);
        storageEmail = await storage.read(key: "emailAddress");
        await storage.write(key: "mobileNumber", value: profileMobileNumber);
        storageMobileNumber = await storage.read(key: "mobileNumber");

        await storage.write(key: "addressLine1", value: profileAddressLine1);
        storageAddressLine1 = await storage.read(key: "addressLine1");
        await storage.write(key: "addressLine2", value: profileAddressLine2);
        storageAddressLine2 = await storage.read(key: "addressLine2");

        await storage.write(key: "addressCity", value: profileCity);
        storageAddressCity = await storage.read(key: "addressCity");
        await storage.write(key: "addressState", value: profileState);
        storageAddressState = await storage.read(key: "addressState");

        await storage.write(key: "poBox", value: profilePinCode);
        storageAddressPoBox = await storage.read(key: "poBox");

        profileAddress =
            "$profileAddressLine1${profileAddressLine1 == "" ? '' : ",\n"}$profileAddressLine2${profileAddressLine2 == "" ? '' : ",\n"}$profileCity${profileCity == "" ? '' : ",\n"}$profileState${profileState == "" ? '' : ",\n"}$profilePinCode";

        log("profileName -> $profileName");
        log("profilePhotoBase64 -> $profilePhotoBase64");
        log("profileDoB -> $profileDoB");
        log("profileEmailId -> $profileEmailId");
        log("profileMobileNumber -> $profileMobileNumber");
        log("profileAddress -> $profileAddress");
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: customerDetails["message"] ??
                    "Error while getting profile data, please try again later",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: labels[346]["labelText"],
                ),
              );
            },
          );
        }
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
