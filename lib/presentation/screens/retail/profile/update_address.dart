// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class UpdateAddressScreen extends StatefulWidget {
  const UpdateAddressScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final TextEditingController _countryController =
      TextEditingController(text: "United Arab Emirates");
  final TextEditingController _address1Controller =
      TextEditingController(text: storageAddressLine1);
  final TextEditingController _address2Controller =
      TextEditingController(text: storageAddressLine2);
  final TextEditingController _cityController =
      TextEditingController(text: storageAddressCity);
  final TextEditingController _stateProvinceController =
      TextEditingController(text: storageAddressState);
  final TextEditingController _poBoxController =
      TextEditingController(text: storageAddressPoBox);

  DropDownCountriesModel selectedCountry = DropDownCountriesModel(
    countryFlagBase64: dhabiCountriesWithFlags[uaeIndex].countryFlagBase64,
    countrynameOrCode: dhabiCountriesWithFlags[uaeIndex].countrynameOrCode,
    isEnabled: dhabiCountriesWithFlags[uaeIndex].isEnabled,
  );
  String? selectedCountryName =
      dhabiCountriesWithFlags[uaeIndex].countrynameOrCode;
  String selectedCountryCode = "AE";
  String selectedCountryCodeInitial = "AE";

  String? selectedValue;

  bool isShowButton = true;
  bool isEmirateSelected = true;

  bool isCountrySelected = true;

  int dhabiCountryIndex = dhabiCountryNames.indexOf(
    LongToShortCode.shortToName(
      profileCountryCode ?? "",
    ),
  );

  int toggles = 0;

  bool isUploading = false;

  bool hasEdited = false;

  late ProfileArgumentModel profileArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    profileArgument =
        ProfileArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final DropdownSelectedBloc residenceSelectedBloc =
        context.read<DropdownSelectedBloc>();
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
                    "Update Address",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    labels[28]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                labels[264]["labelText"],
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.black63,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          BlocBuilder<DropdownSelectedBloc,
                              DropdownSelectedState>(
                            builder: (context, state) {
                              return CustomDropdownCountries(
                                title: "Select a country",
                                items: dhabiCountriesWithFlags,
                                value: selectedCountry,
                                onChanged: (value) {
                                  toggles++;
                                  isCountrySelected = true;
                                  selectedCountry =
                                      value as DropDownCountriesModel;
                                  selectedCountryName =
                                      selectedCountry.countrynameOrCode;
                                  for (var country in dhabiCountries) {
                                    if (country["countryName"] ==
                                        selectedCountryName) {
                                      selectedCountryCode =
                                          country["shortCode"];
                                      break;
                                    }
                                  }

                                  dhabiCountryIndex = dhabiCountryNames
                                      .indexOf(selectedCountryName!);
                                  // emirateIndex = emirates.indexOf(selectedValue!);
                                  residenceSelectedBloc.add(
                                    DropdownSelectedEvent(
                                      isDropdownSelected: true,
                                      toggles: toggles,
                                    ),
                                  );
                                  checkHasEdited();
                                },
                              );
                            },
                          ),
                          // CustomTextField(
                          //   enabled: false,
                          //   color: const Color(0xFFEEEEEE),
                          //   fontColor: const Color.fromRGBO(34, 34, 34, 0.5),
                          //   controller: _countryController,
                          //   onChanged: (p0) {},
                          // ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                labels[265]["labelText"],
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.black63,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            // maxLines: 1,
                            hintText: labels[29]["labelText"],
                            controller: _address1Controller,
                            onChanged: (p0) {
                              if (p0.isEmpty) {
                                isShowButton = false;
                              } else {
                                isShowButton = true;
                              }
                              showButtonBloc.add(
                                ShowButtonEvent(show: isShowButton),
                              );
                              checkHasEdited();
                            },
                          ),
                          const SizeBox(height: 20),
                          Text(
                            labels[266]["labelText"],
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            hintText: labels[29]["labelText"],
                            // maxLines: 1,
                            controller: _address2Controller,
                            onChanged: (p0) {
                              checkHasEdited();
                            },
                          ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                labels[331]["labelText"],
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.black63,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            hintText: labels[331]["labelText"],
                            controller: _cityController,
                            onChanged: (p0) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              if (p0.isEmpty) {
                                isShowButton = false;
                              } else {
                                isShowButton = true;
                              }
                              showButtonBloc.add(
                                ShowButtonEvent(show: isShowButton),
                              );
                              checkHasEdited();
                            },
                          ),
                          const SizeBox(height: 20),
                          Text(
                            "State/Province",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            hintText: "State/Province",
                            controller: _stateProvinceController,
                            onChanged: (p0) {
                              checkHasEdited();
                            },
                          ),
                          // BlocBuilder<DropdownSelectedBloc,
                          //     DropdownSelectedState>(
                          //   builder: buildDropdown,
                          // ),
                          const SizeBox(height: 20),
                          Text(
                            labels[269]["labelText"],
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.black63,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            hintText: "",
                            controller: _poBoxController,
                            onChanged: (p0) {
                              checkHasEdited();
                            },
                          ),
                          const SizeBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: buildSubmitButton,
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildDropdown(BuildContext context, DropdownSelectedState state) {
  //   return CustomDropDown(
  //     title: "Select from the list",
  //     items: items,
  //     value: selectedValue,
  //     onChanged: onDropdownChanged,
  //   );
  // }

  void onDropdownChanged(Object? value) {
    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
    toggles++;
    isEmirateSelected = true;
    selectedValue = value as String;
    dropdownSelectedBloc.add(
      DropdownSelectedEvent(
        isDropdownSelected: isEmirateSelected,
        toggles: toggles,
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton && hasEdited) {
      return Column(
        children: [
          GradientButton(
            onTap: () async {
              if (!isUploading) {
                if (!(dhabiCountries[dhabiCountryIndex]["isEnabled"])
                    // dhabiCountryIndex != uaeIndex
                    ) {
                  log("country -> ${dhabiCountries[dhabiCountryIndex]["countryName"]}");
                  Navigator.pushNamed(
                    context,
                    Routes.notAvailable,
                    arguments: NotAvailableArgumentModel(
                      country: dhabiCountries[dhabiCountryIndex]["countryName"],
                    ).toMap(),
                  );
                } else {
                  final ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  isUploading = true;
                  showButtonBloc.add(ShowButtonEvent(show: isUploading));

                  if (profileArgument.isRetail) {
                    var updateAddressResult =
                        await MapUpdateRetailAddress.mapUpdateRetailAddress(
                      {
                        "addressLine_1": _address1Controller.text,
                        "addressLine_2": _address2Controller.text,
                        "city": _cityController.text,
                        "state": _stateProvinceController.text,
                        "countryCode": selectedCountryCode,
                        "pinCode": _poBoxController.text,
                      },
                      token ?? "",
                    );
                    log("Update Retail Address API response -> $updateAddressResult");

                    isUploading = true;
                    showButtonBloc.add(ShowButtonEvent(show: isUploading));

                    if (updateAddressResult["success"]) {
                      await storage.write(
                          key: "addressCountry", value: selectedCountryName);
                      storageAddressCountry =
                          await storage.read(key: "addressCountry");
                      await storage.write(
                          key: "addressLine1", value: _address1Controller.text);
                      storageAddressLine1 =
                          await storage.read(key: "addressLine1");
                      await storage.write(
                          key: "addressLine2", value: _address2Controller.text);
                      storageAddressLine2 =
                          await storage.read(key: "addressLine2");

                      await storage.write(
                          key: "addressCity", value: _cityController.text);
                      storageAddressCity =
                          await storage.read(key: "addressCity");
                      await storage.write(
                          key: "addressState",
                          value: _stateProvinceController.text);
                      storageAddressState =
                          await storage.read(key: "addressState");

                      await storage.write(
                          key: "addressEmirate", value: selectedValue);
                      storageAddressEmirate =
                          await storage.read(key: "addressEmirate");
                      await storage.write(
                          key: "poBox", value: _poBoxController.text);
                      storageAddressPoBox = await storage.read(key: "poBox");

                      profileAddress =
                          "${storageAddressLine1 ?? ""}${storageAddressLine1 == "" ? "" : ",\n"}${storageAddressLine2 ?? ""}${storageAddressLine2 == "" ? "" : ",\n"}${storageAddressCity ?? ""}${storageAddressCity == "" ? "" : ",\n"}${storageAddressState ?? ""}${storageAddressState == "" ? "" : ",\n"}${storageAddressPoBox ?? ""}";
                      promptSuccessfulAddressUpdate();
                    } else {
                      promptUnsuccessfulAddressUpdate();
                    }
                  } else {
                    log("Update Corporate Address Request -> ${{
                      "addressLine_1": _address1Controller.text,
                      "addressLine_2": _address2Controller.text,
                      "city": _cityController.text,
                      "state": _stateProvinceController.text,
                      "countryCode": selectedCountryCode,
                      "pinCode": _poBoxController.text,
                    }}");

                    var updateAddressResult =
                        await MapChangeAddress.mapChangeAddress(
                      {
                        "addressLine_1": _address1Controller.text,
                        "addressLine_2": _address2Controller.text,
                        "city": _cityController.text,
                        "state": _stateProvinceController.text,
                        "countryCode": selectedCountryCode,
                        "pinCode": _poBoxController.text,
                      },
                      token ?? "",
                    );

                    log("Update Corporate Address API response -> $updateAddressResult");

                    isUploading = true;
                    showButtonBloc.add(ShowButtonEvent(show: isUploading));

                    if (updateAddressResult["success"]) {
                      if (updateAddressResult["isDirectlyCreated"]) {
                        await storage.write(
                            key: "addressCountry", value: selectedCountryName);
                        storageAddressCountry =
                            await storage.read(key: "addressCountry");
                        await storage.write(
                            key: "addressLine1",
                            value: _address1Controller.text);
                        storageAddressLine1 =
                            await storage.read(key: "addressLine1");
                        await storage.write(
                            key: "addressLine2",
                            value: _address2Controller.text);
                        storageAddressLine2 =
                            await storage.read(key: "addressLine2");

                        await storage.write(
                            key: "addressCity", value: _cityController.text);
                        storageAddressCity =
                            await storage.read(key: "addressCity");
                        await storage.write(
                            key: "addressState",
                            value: _stateProvinceController.text);
                        storageAddressState =
                            await storage.read(key: "addressState");

                        await storage.write(
                            key: "addressEmirate", value: selectedValue);
                        storageAddressEmirate =
                            await storage.read(key: "addressEmirate");
                        await storage.write(
                            key: "poBox", value: _poBoxController.text);
                        storageAddressPoBox = await storage.read(key: "poBox");

                        profileAddress =
                            "${storageAddressLine1 ?? ""}${storageAddressLine1 == "" ? "" : ",\n"}${storageAddressLine2 ?? ""}${storageAddressLine2 == "" ? "" : ",\n"}${storageAddressCity ?? ""}${storageAddressCity == "" ? "" : ",\n"}${storageAddressState ?? ""}${storageAddressState == "" ? "" : ",\n"}${storageAddressPoBox ?? ""}";
                        promptSuccessfulAddressUpdate();
                      } else {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                svgAssetPath:
                                    ImageConstants.checkCircleOutlined,
                                title: "Address Update Request Placed",
                                message:
                                    "${messages[121]["messageText"]}: ${updateAddressResult["reference"]}",
                                actionWidget: GradientButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.profile,
                                      arguments: ProfileArgumentModel(
                                        isRetail: profileArgument.isRetail,
                                      ).toMap(),
                                    );
                                  },
                                  text: labels[346]["labelText"],
                                ),
                              );
                            },
                          );
                        }
                      }
                    } else {
                      promptUnsuccessfulAddressUpdate();
                    }
                  }
                }
              }
            },
            text: labels[127]["labelText"],
            auxWidget: isUploading ? const LoaderRow() : const SizeBox(),
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SolidButton(onTap: () {}, text: labels[127]["labelText"]),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      );
    }
  }

  void promptSuccessfulAddressUpdate() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.checkCircleOutlined,
          title: "Address Updated",
          message: "Your address is updated successfully",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                Routes.profile,
                arguments: ProfileArgumentModel(
                  isRetail: profileArgument.isRetail,
                ).toMap(),
              );
            },
            text: labels[347]["labelText"],
          ),
        );
      },
    );
  }

  void promptUnsuccessfulAddressUpdate() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Oops!",
          message:
              "Due to technical error, we are unable to process your request. try again later",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: labels[347]["labelText"],
          ),
        );
      },
    );
  }

  void checkHasEdited() {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (selectedCountryCode == selectedCountryCodeInitial &&
        _address1Controller.text == storageAddressLine1 &&
        _address2Controller.text == storageAddressLine2 &&
        _cityController.text == storageAddressCity &&
        _stateProvinceController.text == storageAddressState &&
        _poBoxController.text == storageAddressPoBox) {
      hasEdited = false;
    } else {
      hasEdited = true;
    }
    showButtonBloc.add(ShowButtonEvent(show: hasEdited));
  }

  @override
  void dispose() {
    _countryController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateProvinceController.dispose();
    _poBoxController.dispose();
    super.dispose();
  }
}
