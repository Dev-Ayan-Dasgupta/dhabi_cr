// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ApplicationTaxCRSScreen extends StatefulWidget {
  const ApplicationTaxCRSScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ApplicationTaxCRSScreen> createState() =>
      _ApplicationTaxCRSScreenState();
}

class _ApplicationTaxCRSScreenState extends State<ApplicationTaxCRSScreen> {
  int progress = 3;
  bool isShowButton = false;

  bool showSelectCountry = false;
  bool showTinPrompt = false;
  bool showTinTextField = false;
  bool showTinDropdown = false;

  bool showSelectCountry2 = false;
  bool showTinPrompt2 = false;
  bool showTinTextField2 = false;
  bool showTinDropdown2 = false;

  bool showSelectCountry3 = false;
  bool showTinPrompt3 = false;
  bool showTinTextField3 = false;
  bool showTinDropdown3 = false;

  bool showSelectCountry4 = false;
  bool showTinPrompt4 = false;
  bool showTinTextField4 = false;
  bool showTinDropdown4 = false;

  bool isCRSreportable = false;
  bool isCRSyes = false;
  bool isCRSno = false;

  int toggles = 0;

  DropDownCountriesModel? selectedCountry;
  DropDownCountriesModel? selectedCountry2;
  DropDownCountriesModel? selectedCountry3;
  DropDownCountriesModel? selectedCountry4;
  String? selectedCountryName;
  String? selectedCountryName2;
  String? selectedCountryName3;
  String? selectedCountryName4;
  int dhabiCountryIndex = -1;
  int dhabiCountryIndex2 = -1;
  int dhabiCountryIndex3 = -1;
  int dhabiCountryIndex4 = -1;

  String? selectedReason;
  String? selectedReason2;
  String? selectedReason3;
  String? selectedReason4;

  bool isCountrySelected = false;
  bool isCountrySelected2 = false;
  bool isCountrySelected3 = false;
  bool isCountrySelected4 = false;
  bool isReasonSelected = false;

  bool hasTIN = false;
  bool isTinYes = false;
  bool isTinYes2 = false;
  bool isTinYes3 = false;
  bool isTinYes4 = false;
  bool isTinNo = false;
  bool isTinNo2 = false;
  bool isTinNo3 = false;
  bool isTinNo4 = false;

  bool isTINvalid = false;
  bool isTINvalid2 = false;
  bool isTINvalid3 = false;
  bool isTINvalid4 = false;

  final TextEditingController _tinController = TextEditingController();
  final TextEditingController _tinController2 = TextEditingController();
  final TextEditingController _tinController3 = TextEditingController();
  final TextEditingController _tinController4 = TextEditingController();

  bool isUploading = false;

  int countriesAdded = 0;
  List internationalTaxes = [];

  List selectedCountries = [];

  late TaxCrsArgumentModel taxCrsArgument;

  @override
  void initState() {
    super.initState();
    initializeArgument();
  }

  void initializeArgument() {
    taxCrsArgument =
        TaxCrsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Routes.applicationTaxFATCA);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, Routes.applicationTaxFATCA);
            },
          ),
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
                      labels[261]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    ApplicationProgress(progress: progress),
                    const SizeBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    labels[277]["labelText"],
                                    style: TextStyles.primaryBold.copyWith(
                                      color: AppColors.primary,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizeBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  labels[278]["labelText"],
                                  style: TextStyles.primary.copyWith(
                                    color: AppColors.dark80,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const Asterisk(),
                              ],
                            ),
                            const SizeBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<ButtonFocussedBloc,
                                    ButtonFocussedState>(
                                  builder: buildResidentYes,
                                ),
                                BlocBuilder<ButtonFocussedBloc,
                                    ButtonFocussedState>(
                                  builder: buildResidentNo,
                                ),
                              ],
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: buildCountryDropdown,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINSection,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINTextField,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildNoTINReasonDropdown,
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: buildCountryDropdown2,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINSection2,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINTextField2,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildNoTINReasonDropdown2,
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: buildCountryDropdown3,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINSection3,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINTextField3,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildNoTINReasonDropdown3,
                            ),
                            BlocBuilder<ApplicationCrsBloc,
                                ApplicationCrsState>(
                              builder: buildCountryDropdown4,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINSection4,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildTINTextField4,
                            ),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildNoTINReasonDropdown4,
                            ),
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
      ),
    );
  }

  Widget buildResidentYes(BuildContext context, ButtonFocussedState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ButtonFocussedBloc crsFocusBloc = context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return SolidButton(
      width: (185 / Dimensions.designWidth).w,
      color: Colors.white,
      fontColor: AppColors.primary,
      boxShadow: [BoxShadows.primary],
      borderColor: isCRSyes
          ? const Color.fromRGBO(0, 184, 148, 0.21)
          : Colors.transparent,
      onTap: () {
        if (countriesAdded == 0) {
          countriesAdded = 1;
        }

        toggles++;
        isCRSreportable = true;
        isCRSyes = true;
        isCRSno = false;
        crsFocusBloc.add(
          ButtonFocussedEvent(isFocussed: isCRSyes, toggles: toggles),
        );
        showSelectCountry = true;
        applicationCrsBloc.add(
          ApplicationCrsEvent(
            showSelectCountry: showSelectCountry,
            showTinPrompt: showTinPrompt,
            showTinTextField: showTinTextField,
            showTinDropdown: showTinDropdown,
          ),
        );
        isShowButton = false;
        showButtonBloc.add(
          ShowButtonEvent(show: isShowButton),
        );
      },
      text: "Yes",
    );
  }

  Widget buildResidentNo(BuildContext context, ButtonFocussedState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ButtonFocussedBloc crsFocusBloc = context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return SolidButton(
      width: (185 / Dimensions.designWidth).w,
      color: Colors.white,
      fontColor: AppColors.primary,
      boxShadow: [BoxShadows.primary],
      borderColor: isCRSno
          ? const Color.fromRGBO(0, 184, 148, 0.21)
          : Colors.transparent,
      onTap: () {
        countriesAdded = 0;
        selectedCountries.clear();
        log("selectedCountries -> $selectedCountries");
        toggles++;
        isCRSreportable = false;
        isCRSyes = false;
        isCRSno = true;
        crsFocusBloc.add(
          ButtonFocussedEvent(
            isFocussed: isCRSno,
            toggles: toggles,
          ),
        );
        selectedCountry =
            selectedCountry2 = selectedCountry3 = selectedCountry4 = null;
        isTinYes = isTinYes2 = isTinYes3 =
            isTinYes4 = isTinNo = isTinNo2 = isTinNo3 = isTinNo4 = false;
        _tinController.clear();
        _tinController2.clear();
        _tinController3.clear();
        _tinController4.clear();
        selectedReason =
            selectedReason2 = selectedReason3 = selectedCountry = null;
        showSelectCountry = false;
        showSelectCountry2 = false;
        showSelectCountry3 = false;
        showSelectCountry4 = false;
        showTinPrompt = false;
        showTinPrompt2 = false;
        showTinPrompt3 = false;
        showTinPrompt4 = false;
        showTinDropdown = false;
        showTinDropdown2 = false;
        showTinDropdown3 = false;
        showTinDropdown4 = false;
        showTinTextField = false;
        showTinTextField2 = false;
        showTinTextField3 = false;
        showTinTextField4 = false;
        applicationCrsBloc.add(
          ApplicationCrsEvent(
              showSelectCountry: showSelectCountry,
              showTinPrompt: showTinPrompt,
              showTinTextField: showTinTextField,
              showTinDropdown: showTinDropdown),
        );
        isShowButton = true;
        showButtonBloc.add(
          ShowButtonEvent(show: isShowButton),
        );
      },
      text: "No",
    );
  }

  Widget buildCountryDropdown(BuildContext context, ApplicationCrsState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showSelectCountry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 20),
          Row(
            children: [
              Text(
                "Select Country",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomDropdownCountries(
            title: labels[264]["labelText"],
            items: dhabiCountriesWithFlags,
            value: selectedCountry,
            onChanged: (value) {
              log("selectedCountries before -> $selectedCountries");
              if (selectedCountries.contains(value)) {
                log("selectedCountries.contains(value) -> ${selectedCountries.contains(value)}");
                promptSelectedCountryError(value as DropDownCountriesModel);
              } else {
                if (selectedCountries.contains(selectedCountry)) {
                  selectedCountries.remove(selectedCountry);
                }
                selectedCountries.add(value);
                log("selectedCountries after -> $selectedCountries");
                toggles++;
                isCountrySelected = true;
                selectedCountry = value as DropDownCountriesModel;
                selectedCountryName = selectedCountry?.countrynameOrCode;
                dhabiCountryIndex =
                    dhabiCountryNames.indexOf(selectedCountryName!);
                log("dhabiCountryIndex -> $dhabiCountryIndex");
                // isCountrySelected = true;
                showTinPrompt = true;
                applicationCrsBloc.add(
                  ApplicationCrsEvent(
                    showSelectCountry: showSelectCountry,
                    showTinPrompt: showTinPrompt,
                    showTinTextField: showTinTextField,
                    showTinDropdown: showTinDropdown,
                  ),
                );
                showButtonBloc.add(ShowButtonEvent(show: showTinPrompt));
              }
            },
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildCountryDropdown2(
      BuildContext context, ApplicationCrsState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showSelectCountry2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 20),
          Row(
            children: [
              Text(
                "Select Country",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomDropdownCountries(
            title: labels[264]["labelText"],
            items: dhabiCountriesWithFlags,
            value: selectedCountry2,
            onChanged: (value) {
              log("selectedCountries before -> $selectedCountries");
              if (selectedCountries.contains(value)) {
                log("selectedCountries.contains(value) -> ${selectedCountries.contains(value)}");
                promptSelectedCountryError(value as DropDownCountriesModel);
              } else {
                if (selectedCountries.contains(selectedCountry2)) {
                  selectedCountries.remove(selectedCountry2);
                }
                selectedCountries.add(value);
                log("selectedCountries after -> $selectedCountries");
                toggles++;
                isCountrySelected2 = true;
                selectedCountry2 = value as DropDownCountriesModel;
                selectedCountryName2 = selectedCountry2?.countrynameOrCode;
                log("selectedCountry2 -> $selectedCountry2");
                log("selectedCountryName2 -> $selectedCountryName2");
                dhabiCountryIndex2 =
                    dhabiCountryNames.indexOf(selectedCountryName2!);
                log("dhabiCountryIndex -> $dhabiCountryIndex2");
                // isCountrySelected = true;
                showTinPrompt2 = true;
                applicationCrsBloc.add(
                  ApplicationCrsEvent(
                    showSelectCountry: showSelectCountry2,
                    showTinPrompt: showTinPrompt2,
                    showTinTextField: showTinTextField2,
                    showTinDropdown: showTinDropdown2,
                  ),
                );
                showButtonBloc.add(ShowButtonEvent(show: showTinPrompt));
              }
            },
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildCountryDropdown3(
      BuildContext context, ApplicationCrsState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showSelectCountry3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 20),
          Row(
            children: [
              Text(
                "Select Country",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomDropdownCountries(
            title: labels[264]["labelText"],
            items: dhabiCountriesWithFlags,
            value: selectedCountry3,
            onChanged: (value) {
              log("selectedCountries before -> $selectedCountries");
              if (selectedCountries.contains(value)) {
                log("selectedCountries.contains(value) -> ${selectedCountries.contains(value)}");
                promptSelectedCountryError(value as DropDownCountriesModel);
              } else {
                if (selectedCountries.contains(selectedCountry3)) {
                  selectedCountries.remove(selectedCountry3);
                }
                selectedCountries.add(value);
                log("selectedCountries after -> $selectedCountries");
                toggles++;
                isCountrySelected3 = true;
                selectedCountry3 = value as DropDownCountriesModel;
                selectedCountryName3 = selectedCountry3?.countrynameOrCode;
                dhabiCountryIndex3 =
                    dhabiCountryNames.indexOf(selectedCountryName3!);
                log("dhabiCountryIndex -> $dhabiCountryIndex3");
                // isCountrySelected = true;
                showTinPrompt3 = true;
                applicationCrsBloc.add(
                  ApplicationCrsEvent(
                    showSelectCountry: showSelectCountry3,
                    showTinPrompt: showTinPrompt3,
                    showTinTextField: showTinTextField3,
                    showTinDropdown: showTinDropdown3,
                  ),
                );
                showButtonBloc.add(ShowButtonEvent(show: showTinPrompt));
              }
            },
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildCountryDropdown4(
      BuildContext context, ApplicationCrsState state) {
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showSelectCountry4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 20),
          Row(
            children: [
              Text(
                "Select Country",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomDropdownCountries(
            title: labels[264]["labelText"],
            items: dhabiCountriesWithFlags,
            value: selectedCountry4,
            onChanged: (value) {
              log("selectedCountries before -> $selectedCountries");
              if (selectedCountries.contains(value)) {
                log("selectedCountries.contains(value) -> ${selectedCountries.contains(value)}");
                promptSelectedCountryError(value as DropDownCountriesModel);
              } else {
                if (selectedCountries.contains(selectedCountry4)) {
                  selectedCountries.remove(selectedCountry4);
                }
                selectedCountries.add(value);
                log("selectedCountries after -> $selectedCountries");
                toggles++;
                isCountrySelected4 = true;
                selectedCountry4 = value as DropDownCountriesModel;
                selectedCountryName4 = selectedCountry4?.countrynameOrCode;

                dhabiCountryIndex4 =
                    dhabiCountryNames.indexOf(selectedCountryName4!);
                log("dhabiCountryIndex -> $dhabiCountryIndex4");
                // isCountrySelected = true;
                showTinPrompt4 = true;
                applicationCrsBloc.add(
                  ApplicationCrsEvent(
                    showSelectCountry: showSelectCountry4,
                    showTinPrompt: showTinPrompt4,
                    showTinTextField: showTinTextField4,
                    showTinDropdown: showTinDropdown4,
                  ),
                );
                showButtonBloc.add(ShowButtonEvent(show: showTinPrompt));
              }
            },
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINSection(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ButtonFocussedBloc tinFocusBloc = context.read<ButtonFocussedBloc>();

    if (showTinPrompt) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labels[281]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinYes
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = true;
                      isTinYes = true;
                      isTinNo = false;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinYes,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField = true;
                      showTinDropdown = false;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                      if (_tinController.text.isEmpty) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinNo
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = false;
                      isTinYes = false;
                      isTinNo = true;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinNo,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField = false;
                      showTinDropdown = true;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINSection2(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ButtonFocussedBloc tinFocusBloc = context.read<ButtonFocussedBloc>();

    if (showTinPrompt2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labels[281]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinYes2
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = true;
                      isTinYes2 = true;
                      isTinNo2 = false;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinYes2,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField2 = true;
                      showTinDropdown2 = false;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason2 == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                      if (_tinController2.text.isEmpty) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinNo2
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = false;
                      isTinYes2 = false;
                      isTinNo2 = true;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinNo2,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField2 = false;
                      showTinDropdown2 = true;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason2 == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINSection3(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ButtonFocussedBloc tinFocusBloc = context.read<ButtonFocussedBloc>();

    if (showTinPrompt3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labels[281]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinYes3
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = true;
                      isTinYes3 = true;
                      isTinNo3 = false;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinYes3,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField3 = true;
                      showTinDropdown3 = false;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason3 == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                      if (_tinController3.text.isEmpty) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinNo3
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = false;
                      isTinYes3 = false;
                      isTinNo3 = true;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinNo3,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField3 = false;
                      showTinDropdown3 = true;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason3 == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINSection4(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ButtonFocussedBloc tinFocusBloc = context.read<ButtonFocussedBloc>();

    if (showTinPrompt4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labels[281]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinYes4
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = true;
                      isTinYes4 = true;
                      isTinNo4 = false;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinYes4,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField4 = true;
                      showTinDropdown4 = false;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason4 == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                      if (_tinController4.text.isEmpty) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    width: (185 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.primary,
                    boxShadow: [BoxShadows.primary],
                    borderColor: isTinNo4
                        ? const Color.fromRGBO(0, 184, 148, 0.21)
                        : Colors.transparent,
                    onTap: () {
                      isCRSreportable = false;
                      isTinYes4 = false;
                      isTinNo4 = true;
                      tinFocusBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isTinNo4,
                          toggles: toggles,
                        ),
                      );
                      showTinTextField4 = false;
                      showTinDropdown4 = true;

                      showButtonBloc.add(
                        ShowButtonEvent(show: isShowButton),
                      );
                      if (selectedReason4 == null) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINTextField(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showTinTextField) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                "Please provide your Tax Identification Number",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomTextField(
            controller: _tinController,
            onChanged: (p0) {
              if (_tinController.text.isNotEmpty) {
                isTINvalid = true;
                isShowButton = true;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              } else {
                isTINvalid = false;
                isShowButton = false;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              }
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINTextField2(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showTinTextField2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                "Please provide your Tax Identification Number",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomTextField(
            controller: _tinController2,
            onChanged: (p0) {
              if (_tinController2.text.isNotEmpty) {
                isTINvalid2 = true;
                isShowButton = true;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              } else {
                isTINvalid2 = false;
                isShowButton = false;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              }
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINTextField3(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showTinTextField3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                "Please provide your Tax Identification Number",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomTextField(
            controller: _tinController3,
            onChanged: (p0) {
              if (_tinController3.text.isNotEmpty) {
                isTINvalid3 = true;
                isShowButton = true;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              } else {
                isTINvalid3 = false;
                isShowButton = false;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              }
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTINTextField4(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showTinTextField4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                "Please provide your Tax Identification Number",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomTextField(
            controller: _tinController4,
            onChanged: (p0) {
              if (_tinController4.text.isNotEmpty) {
                isTINvalid3 = true;
                isShowButton = true;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              } else {
                isTINvalid4 = false;
                isShowButton = false;
                showButtonBloc.add(
                  ShowButtonEvent(show: isShowButton),
                );
              }
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildNoTINReasonDropdown(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    if (showTinDropdown) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                labels[282]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 9),
          CustomDropDown(
            title: "Reason",
            items: noTinReasonDDs,
            value: selectedReason,
            onChanged: (value) {
              toggles++;
              isCountrySelected = true;
              selectedReason = value as String;
              isShowButton = true;
              showButtonBloc.add(
                ShowButtonEvent(show: isShowButton),
              );
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildNoTINReasonDropdown2(
      BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showTinDropdown2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                labels[282]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 9),
          CustomDropDown(
            title: "Reason",
            items: noTinReasonDDs,
            value: selectedReason2,
            onChanged: (value) {
              toggles++;
              isCountrySelected2 = true;
              selectedReason2 = value as String;
              isShowButton = true;
              showButtonBloc.add(
                ShowButtonEvent(show: isShowButton),
              );
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildNoTINReasonDropdown3(
      BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    if (showTinDropdown3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                labels[282]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 9),
          CustomDropDown(
            title: "Reason",
            items: noTinReasonDDs,
            value: selectedReason3,
            onChanged: (value) {
              toggles++;
              isCountrySelected3 = true;
              selectedReason3 = value as String;
              applicationCrsBloc.add(
                ApplicationCrsEvent(
                  showSelectCountry: showSelectCountry3,
                  showTinPrompt: showTinPrompt3,
                  showTinTextField: showTinTextField3,
                  showTinDropdown: showTinDropdown3,
                ),
              );
              isShowButton = true;
              showButtonBloc.add(
                ShowButtonEvent(show: isShowButton),
              );
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildNoTINReasonDropdown4(
      BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final ApplicationCrsBloc applicationCrsBloc =
        context.read<ApplicationCrsBloc>();
    if (showTinDropdown4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Row(
            children: [
              Text(
                labels[282]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 9),
          CustomDropDown(
            title: "Reason",
            items: noTinReasonDDs,
            value: selectedReason4,
            onChanged: (value) {
              toggles++;
              isCountrySelected4 = true;
              selectedReason4 = value as String;
              applicationCrsBloc.add(
                ApplicationCrsEvent(
                  showSelectCountry: showSelectCountry4,
                  showTinPrompt: showTinPrompt4,
                  showTinTextField: showTinTextField4,
                  showTinDropdown: showTinDropdown4,
                ),
              );
              isShowButton = true;
              showButtonBloc.add(
                ShowButtonEvent(show: isShowButton),
              );
            },
          ),
          const SizeBox(height: 10),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton) {
      return Column(
        children: [
          const SizeBox(height: 20),
          Ternary(
            condition: isCRSno || countriesAdded == 4,
            truthy: const SizeBox(),
            falsy: SolidButton(
              onTap: () {
                isShowButton = false;
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                showButtonBloc.add(ShowButtonEvent(show: isShowButton));
                final ApplicationCrsBloc applicationCrsBloc =
                    context.read<ApplicationCrsBloc>();
                countriesAdded++;
                log("countriesAdded -> $countriesAdded");
                if (countriesAdded == 2) {
                  showSelectCountry2 = true;
                  applicationCrsBloc.add(
                    ApplicationCrsEvent(
                      showSelectCountry: showSelectCountry2,
                      showTinPrompt: showTinPrompt2,
                      showTinTextField: showTinTextField2,
                      showTinDropdown: showTinDropdown2,
                    ),
                  );
                }
                if (countriesAdded == 3) {
                  showSelectCountry3 = true;
                  applicationCrsBloc.add(
                    ApplicationCrsEvent(
                      showSelectCountry: showSelectCountry3,
                      showTinPrompt: showTinPrompt3,
                      showTinTextField: showTinTextField3,
                      showTinDropdown: showTinDropdown3,
                    ),
                  );
                }
                if (countriesAdded == 4) {
                  showButtonBloc
                      .add(ShowButtonEvent(show: countriesAdded == 4));
                  showSelectCountry4 = true;
                  applicationCrsBloc.add(
                    ApplicationCrsEvent(
                      showSelectCountry: showSelectCountry4,
                      showTinPrompt: showTinPrompt4,
                      showTinTextField: showTinTextField4,
                      showTinDropdown: showTinDropdown4,
                    ),
                  );
                }
              },
              auxWidget: Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: AppColors.primary,
                    size: (16 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(width: 10),
                ],
              ),
              text: labels[284]["labelText"],
              color: Colors.white,
              boxShadow: [BoxShadows.primary],
              fontColor: AppColors.primary,
            ),
          ),
          const SizeBox(height: 15),
          GradientButton(
            onTap: () async {
              if (!isUploading) {
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                isUploading = true;
                showButtonBloc.add(ShowButtonEvent(show: isUploading));
                // log("countryCode -> ${dhabiCountries[dhabiCountryIndex]["shortCode"]}");
                log("noTINReason -> ${selectedReason ?? ""}");

                if (isCRSreportable) {
                  if (countriesAdded == 0) {
                    countriesAdded++;
                  }
                }

                await storage.write(
                    key: "taxCountry", value: selectedCountryName);
                storageTaxCountry = await storage.read(key: "taxCountry");
                await storage.write(
                    key: "isTinYes", value: isTinYes.toString());
                storageIsTinYes = await storage.read(key: "isTinYes") == "true";
                await storage.write(key: "crsTin", value: _tinController.text);
                storageCrsTin = await storage.read(key: "crsTin");
                await storage.write(key: "noTinReason", value: selectedReason);
                storageNoTinReason = await storage.read(key: "noTinReason");

                for (int i = 0; i < countriesAdded; i++) {
                  if (i == 0) {
                    internationalTaxes.add(
                      {
                        "countryCode": !dhabiCountryNames
                                .contains(selectedCountryName ?? "")
                            ? ""
                            : dhabiCountries[dhabiCountryNames
                                .indexOf(selectedCountryName!)]["shortCode"],
                        "isTIN": isTinYes,
                        "tin": _tinController.text,
                        "noTINReason": selectedReason,
                      },
                    );
                  }
                  if (i == 1) {
                    internationalTaxes.add(
                      {
                        "countryCode": !dhabiCountryNames
                                .contains(selectedCountryName2 ?? "")
                            ? ""
                            : dhabiCountries[dhabiCountryNames
                                .indexOf(selectedCountryName2!)]["shortCode"],
                        "isTIN": isTinYes2,
                        "tin": _tinController2.text,
                        "noTINReason": selectedReason2,
                      },
                    );
                  }
                  if (i == 2) {
                    internationalTaxes.add(
                      {
                        "countryCode": !dhabiCountryNames
                                .contains(selectedCountryName3 ?? "")
                            ? ""
                            : dhabiCountries[dhabiCountryNames
                                .indexOf(selectedCountryName3!)]["shortCode"],
                        "isTIN": isTinYes3,
                        "tin": _tinController3.text,
                        "noTINReason": selectedReason3,
                      },
                    );
                  }
                  if (i == 3) {
                    internationalTaxes.add(
                      {
                        "countryCode": !dhabiCountryNames
                                .contains(selectedCountryName4 ?? "")
                            ? ""
                            : dhabiCountries[dhabiCountryNames
                                .indexOf(selectedCountryName4!)]["shortCode"],
                        "isTIN": isTinYes4,
                        "tin": _tinController4.text,
                        "noTINReason": selectedReason4,
                      },
                    );
                  }
                }

                for (int i = 0; i < countriesAdded; i++) {
                  log("International Taxes -> ${internationalTaxes[i]}");
                }

                await storage.write(
                    key: "internationalTaxes",
                    value: jsonEncode(internationalTaxes));

                storageInternationalTaxes = jsonDecode(
                    await storage.read(key: "internationalTaxes") ?? "");

                log("storageInternationalTaxes -> $storageInternationalTaxes");

                if (context.mounted) {
                  Navigator.pushNamed(
                    context,
                    Routes.applicationAccount,
                    arguments: ApplicationAccountArgumentModel(
                      isInitial: true,
                      isRetail: true,
                      savingsAccountsCreated: 0,
                      currentAccountsCreated: 0,
                    ).toMap(),
                  );
                }
                isUploading = false;
                showButtonBloc.add(ShowButtonEvent(show: isUploading));

                await storage.write(key: "stepsCompleted", value: 8.toString());
                storageStepsCompleted =
                    int.parse(await storage.read(key: "stepsCompleted") ?? "0");
              }
            },
            text: labels[127]["labelText"],
            auxWidget: isUploading ? const LoaderRow() : const SizeBox(),
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.paddingOf(context).bottom,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SolidButton(onTap: () {}, text: labels[127]["labelText"]),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.paddingOf(context).bottom,
          ),
        ],
      );
    }
  }

  void promptSelectedCountryError(DropDownCountriesModel country) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Duplicate Country Selected",
          message:
              "Your tax information for ${country.countrynameOrCode} has already been submitted.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Go back",
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tinController.dispose();
    super.dispose();
  }
}
