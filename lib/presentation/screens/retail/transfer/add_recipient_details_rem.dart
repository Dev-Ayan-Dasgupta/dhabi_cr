// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/transfer/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/configurations/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class AddRecipientDetailsRemittanceScreen extends StatefulWidget {
  const AddRecipientDetailsRemittanceScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<AddRecipientDetailsRemittanceScreen> createState() =>
      _AddRecipientDetailsRemittanceScreenState();
}

class _AddRecipientDetailsRemittanceScreenState
    extends State<AddRecipientDetailsRemittanceScreen> {
  bool isChecked = false;

  bool mandatoryFilling = false;

  bool isFetchingFields = false;
  bool isWalletSelectedd = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  Map<String, dynamic> dynamicFields = {};

  List textEditingControllers = [];
  List<List<String>> dropDownLists = [];
  List<int> toggles = [];

  int toggles2 = 0;

  int textEditingControllersAdded = -1;
  int togglesAdded = -1;
  int mandatoryFields = 0;
  int mandatorySatisfiedCount = 0;

  int dropDowns = 0;
  int dates = 0;

  int widgetsBuilt = 0;

  bool allValid = false;

  bool isFetchingExchangeRate = false;

  String? selectedWallet;

  List<String> walletsToShow = [];

  List fieldIds = [];
  List<FieldVariables> fieldVariables = [];

  int benBankNameMin = 0;
  int benBankNameMax = 0;
  int benAccountMin = 0;
  int benAccountMax = 0;
  int benBankCodeMin = 0;
  int benBankCodeMax = 0;
  int benSubBankCodeMin = 0;
  int benSubBankCodeMax = 0;
  int benMobileNoMin = 0;
  int benMobileNoMax = 0;
  int walletNumberMin = 0;
  int walletNumberMax = 0;
  int benCustomerNameMin = 0;
  int benCustomerNameMax = 0;
  int benAddressMin = 0;
  int benAddressMax = 0;
  int benCityMin = 0;
  int benCityMax = 0;
  int benSwiftCodeMin = 0;
  int benSwiftCodeMax = 0;
  int benIdNoMin = 0;
  int benIdNoMax = 0;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateWallet();
    getDynamicFields();
    fieldIds.clear();
    fieldVariables.clear();
    benBankName = "";
    benBankCode = "";
    benMobileNo = "";
    benSubBankCode = "";
    eidExpiryDate = "";
    benIdType = "";
    benIdNo = "";
    benIdExpiryDate = "";
    benCustomerName = "";
    benAddress = "";
    benCity = "";
    benSwiftCode = "";
    walletNumber = "";
    receiverAccountNumber = "";
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    remittancePurpose = null;
    sourceOfFunds = null;
    relation = null;
    idType = null;
  }

  Future<void> getDynamicFields() async {
    try {
      isFetchingFields = true;
      setState(() {});

      log("getDynamicFields API Req -> ${{
        "countryShortCode": beneficiaryCountryCode,
        "isSwiftTransfer": !isTerraPaySupported,
        "isBusinessTransfer": isBusinessTransfer,
      }}");
      dynamicFields = await MapDynamicFields.mapDynamicFields({
        "countryShortCode": beneficiaryCountryCode,
        "isSwiftTransfer": !isTerraPaySupported,
        "isBusinessTransfer": isBusinessTransfer,
      });
      log("dynamicFields -> $dynamicFields");

      if (dynamicFields["success"]) {
        textEditingControllers.clear();
        dropDownLists.clear();
        for (var field in dynamicFields["dynamicFields"]) {
          // if (field["type"] == "Text") {
          // if (isWalletSelected) {
          //   if (field["isWallet"]) {
          //     textEditingControllers.add(TextEditingController());
          //   }
          // } else {
          //   if (field["isBank"]) {
          //     textEditingControllers.add(TextEditingController());
          //   }
          // }

          textEditingControllers.add(TextEditingController());

          // } else
          // if (field["type"] == "Dropdown") {
          if (field["dropdownValues"] != null) {
            dropDowns++;
          }
          dropDownLists.add([]);
          // }
        }
        log("dropDownLists length -> $dropDowns");
        log("tec added -> ${textEditingControllers.length}");
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: dynamicFields["message"] ??
                    "Error fetching dynamic fields.",
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

      isFetchingFields = false;
      setState(() {});
    } catch (_) {
      rethrow;
    }
  }

  void populateWallet() {
    String countryName = "";
    for (var country in dhabiCountries) {
      if (country["shortCode"] == beneficiaryCountryCode) {
        countryName = country["countryName"];
        break;
      }
    }
    log("countryName -> $countryName");
    walletsToShow.clear();
    for (var walletName in walletNames) {
      if (walletName.toLowerCase().contains(countryName.toLowerCase())) {
        walletsToShow.add(walletName.split('-').last);
      }
    }
    log("walletsToShow -> $walletsToShow");
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
                    labels[194]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Ternary(
                    condition: isFetchingFields,
                    truthy: Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return const ShimmerAddRecipientDetailsTile();
                        },
                        separatorBuilder: (context, index) {
                          return const SizeBox(height: 10);
                        },
                        itemCount: 10,
                      ),
                    ), // ! Wallet
                    falsy: isWalletSelected
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Mobile Wallet",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.dark80,
                                        fontSize:
                                            (14 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    const Asterisk(),
                                  ],
                                ),
                                const SizeBox(height: 8),
                                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                  builder: (context, state) {
                                    return CustomDropDown(
                                      title: "Select from the list",
                                      value: selectedWallet,
                                      items: walletsToShow,
                                      onChanged: (value) {
                                        final DropdownSelectedBloc
                                            dropdownSelectedBloc = context
                                                .read<DropdownSelectedBloc>();
                                        final ShowButtonBloc showButtonBloc =
                                            context.read<ShowButtonBloc>();
                                        toggles2++;
                                        isWalletSelectedd = true;
                                        selectedWallet = value as String;
                                        providerName = selectedWallet;
                                        // benBankName = selectedWallet ?? "";
                                        showButtonBloc.add(ShowButtonEvent(
                                            show: isWalletSelectedd));
                                        dropdownSelectedBloc.add(
                                            DropdownSelectedEvent(
                                                isDropdownSelected: true,
                                                toggles: toggles2));
                                      },
                                    );
                                  },
                                ),
                                const SizeBox(height: 15),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        dynamicFields["dynamicFields"]?.length,
                                    itemBuilder: (context, index) {
                                      // fieldIds.clear();
                                      if (dynamicFields["dynamicFields"]?[index]
                                              ["isWallet"] ==
                                          false) {
                                        return const SizeBox();
                                      } else {
                                        if (widgetsBuilt ==
                                            dynamicFields["dynamicFields"]
                                                ?.length) {
                                          widgetsBuilt = 0;
                                          textEditingControllersAdded = -1;
                                          // dropDownListsAdded = -1;
                                          togglesAdded = -1;
                                        }
                                        // if (dynamicFields["dynamicFields"][index]["type"] ==
                                        // "Text") {
                                        textEditingControllersAdded++;
                                        log("textEditingControllersAdded -> $textEditingControllersAdded");
                                        // } else
                                        // if (dynamicFields["dynamicFields"][index]["type"] ==
                                        //     "Dropdown") {
                                        toggles.add(0);
                                        togglesAdded++;
                                        // dropDownListsAdded++;
                                        // dropDownLists.add([]);
                                        dropDownLists[index].clear();
                                        // log("dropDownListsAdded -> $dropDownListsAdded");

                                        if (dynamicFields["dynamicFields"]
                                            [index]["isManadatory"]) {
                                          if (!(fieldIds.contains(
                                              dynamicFields["dynamicFields"]
                                                  [index]["fieldId"]))) {
                                            fieldIds.add(
                                                dynamicFields["dynamicFields"]
                                                    [index]["fieldId"]);

                                            log("fieldIds -> $fieldIds | length -> ${fieldIds.length}");

                                            populateFieldVariables();
                                            removeDuplicateVaribales(
                                                fieldVariables);
                                          }
                                        }

                                        if (dynamicFields["dynamicFields"]
                                                [index]["dropdownValues"] !=
                                            null) {
                                          jsonDecode(
                                                  dynamicFields["dynamicFields"]
                                                              [index]
                                                          ["dropdownValues"]
                                                      .replaceAll('\\', ''))
                                              .forEach((key, value) =>
                                                  dropDownLists[index]
                                                      .add(value));
                                        } else {}

                                        // }

                                        if (dynamicFields["dynamicFields"]
                                            [index]["isManadatory"]) {
                                          mandatoryFields++;

                                          widgetsBuilt++;
                                          log("widgetsBuilt -> $widgetsBuilt");
                                        }

                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  dynamicFields["dynamicFields"]
                                                      [index]["label"],
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color: AppColors.dark80,
                                                    fontSize: (14 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                dynamicFields["dynamicFields"]
                                                        [index]["isManadatory"]
                                                    ? const Asterisk()
                                                    : const SizeBox(),
                                              ],
                                            ),
                                            const SizeBox(height: 7),
                                            dynamicFields["dynamicFields"]
                                                        [index]["type"] ==
                                                    "Date"
                                                ? Ternary(
                                                    condition: Platform.isIOS,
                                                    truthy: SizedBox(
                                                      height: (100 /
                                                              Dimensions
                                                                  .designHeight)
                                                          .h,
                                                      child:
                                                          CupertinoDatePicker(
                                                        minimumDate: DateTime
                                                                .now()
                                                            .subtract(
                                                                const Duration(
                                                                    days: 365 *
                                                                        10)),
                                                        initialDateTime:
                                                            DateTime.now(),
                                                        maximumDate:
                                                            DateTime.now().add(
                                                                const Duration(
                                                                    days: 365 *
                                                                        10)),
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .date,
                                                        onDateTimeChanged:
                                                            (p0) {
                                                          final ShowButtonBloc
                                                              showButtonBloc =
                                                              context.read<
                                                                  ShowButtonBloc>();
                                                          eidExpiryDate =
                                                              DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(p0);
                                                          log("eidExpiryDate -> $eidExpiryDate");
                                                          int fldIndx =
                                                              returnFieldIndex(
                                                                  "BenIdExpiryDate");
                                                          fieldVariables[
                                                                  fldIndx] =
                                                              FieldVariables(
                                                                  text:
                                                                      eidExpiryDate,
                                                                  minLength: 0,
                                                                  maxLength: 0);
                                                          // eidExpiryDate;

                                                          log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
                                                          mandatoryFilling =
                                                              checkMandatoryFilling();
                                                          showButtonBloc.add(
                                                              const ShowButtonEvent(
                                                                  show: true));
                                                        },
                                                      ),
                                                    ),
                                                    falsy: DatePickerWidget(
                                                      looping: false,
                                                      firstDate: DateTime.now()
                                                          .subtract(
                                                              const Duration(
                                                                  days: 365 *
                                                                      10)),
                                                      initialDate:
                                                          DateTime.now(),
                                                      lastDate: DateTime.now()
                                                          .add(const Duration(
                                                              days: 365 * 10)),
                                                      dateFormat:
                                                          "dd-MMMM-yyyy",
                                                      onChange: (p0, _) {
                                                        final ShowButtonBloc
                                                            showButtonBloc =
                                                            context.read<
                                                                ShowButtonBloc>();
                                                        eidExpiryDate =
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(p0);
                                                        log("eidExpiryDate -> $eidExpiryDate");
                                                        int fldIndx =
                                                            returnFieldIndex(
                                                                "BenIdExpiryDate");
                                                        fieldVariables[
                                                                fldIndx] =
                                                            FieldVariables(
                                                                text:
                                                                    eidExpiryDate,
                                                                minLength: 0,
                                                                maxLength: 0);
                                                        // eidExpiryDate;

                                                        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
                                                        mandatoryFilling =
                                                            checkMandatoryFilling();
                                                        showButtonBloc.add(
                                                            const ShowButtonEvent(
                                                                show: true));
                                                      },
                                                      pickerTheme:
                                                          DateTimePickerTheme(
                                                        dividerColor:
                                                            AppColors.dark30,
                                                        itemTextStyle:
                                                            TextStyles
                                                                .primaryMedium
                                                                .copyWith(
                                                          color:
                                                              AppColors.primary,
                                                          fontSize: (20 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : dynamicFields["dynamicFields"]
                                                            [index]["type"] ==
                                                        "Mobile"
                                                    ? Row(
                                                        children: [
                                                          // Text(
                                                          //   "+971",
                                                          //   style: TextStyles
                                                          //       .primaryMedium
                                                          //       .copyWith(
                                                          //           color: Colors
                                                          //               .black),
                                                          // ),
                                                          // const SizeBox(
                                                          //     width: 10),
                                                          Expanded(
                                                            child: BlocBuilder<
                                                                ShowButtonBloc,
                                                                ShowButtonState>(
                                                              builder: (context,
                                                                  state) {
                                                                return CustomTextField(
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .phone,
                                                                  controller:
                                                                      textEditingControllers[
                                                                          index],
                                                                  // maxLength: dynamicFields["dynamicFields"]
                                                                  //     [index]["maxLength"],
                                                                  onChanged:
                                                                      (p0) {
                                                                    final ShowButtonBloc
                                                                        showButtonBloc =
                                                                        context.read<
                                                                            ShowButtonBloc>();
                                                                    mapControllerToFieldId(
                                                                        index,
                                                                        p0);

                                                                    // if (dynamicFields[
                                                                    //             "dynamicFields"]
                                                                    //         [index][
                                                                    //     "isManadatory"]) {
                                                                    //   for (var i =
                                                                    //           0;
                                                                    //       i <
                                                                    //           dynamicFields["dynamicFields"]
                                                                    //               .length;
                                                                    //       i++) {
                                                                    //     if (textEditingControllers[i].text.length <
                                                                    //             dynamicFields["dynamicFields"][i][
                                                                    //                 "minLength"] ||
                                                                    //         textEditingControllers[i].text.length >
                                                                    //             dynamicFields["dynamicFields"][i]["maxLength"]) {
                                                                    //       allValid =
                                                                    //           false;
                                                                    //       break;
                                                                    //     }
                                                                    //     allValid =
                                                                    //         true;
                                                                    //   }
                                                                    //   log("allValid -> $allValid");
                                                                    //   // if (p0.length == 1) {
                                                                    //   //   mandatorySatisfiedCount++;
                                                                    //   //   log("mandatorySatisfiedCount -> $mandatorySatisfiedCount");
                                                                    //   // } else if (p0.length <
                                                                    //   //     dynamicFields["dynamicFields"]
                                                                    //   //         [index]["minLength"]) {
                                                                    //   //   mandatorySatisfiedCount--;
                                                                    //   //   log("mandatorySatisfiedCount -> $mandatorySatisfiedCount");
                                                                    //   // }
                                                                    // }

                                                                    if (benCustomerName.isEmpty ||
                                                                        benAddress
                                                                            .isEmpty ||
                                                                        benCity
                                                                            .isEmpty) {
                                                                      allValid =
                                                                          false;
                                                                    } else {
                                                                      allValid =
                                                                          true;
                                                                    }
                                                                    log("allValid -> $allValid");

                                                                    log("benCustomerName -> $benCustomerName");
                                                                    log("benAddress -> $benAddress");
                                                                    log("benCity -> $benCity");

                                                                    mandatoryFilling =
                                                                        checkMandatoryFilling();

                                                                    showButtonBloc.add(
                                                                        const ShowButtonEvent(
                                                                            show:
                                                                                true));
                                                                  },
                                                                  borderColor: ((textEditingControllers[index].text.length > dynamicFields["dynamicFields"][index]["maxLength"] || textEditingControllers[index].text.length < dynamicFields["dynamicFields"][index]["minLength"]) &&
                                                                          textEditingControllers[index]
                                                                              .text
                                                                              .isNotEmpty &&
                                                                          dynamicFields["dynamicFields"][index]
                                                                              [
                                                                              "isManadatory"])
                                                                      ? AppColors
                                                                          .red100
                                                                      : const Color(
                                                                          0xFFEEEEEE),
                                                                  hintText: dynamicFields["dynamicFields"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "placeholderText"] ??
                                                                      "${dynamicFields["dynamicFields"][index]["label"]} must be between ${dynamicFields["dynamicFields"][index]["minLength"]} and ${dynamicFields["dynamicFields"][index]["maxLength"]} characters",
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : dynamicFields["dynamicFields"]
                                                                    [index]
                                                                ["type"] ==
                                                            "Text"
                                                        ? BlocBuilder<
                                                            ShowButtonBloc,
                                                            ShowButtonState>(
                                                            builder: (context,
                                                                state) {
                                                              return CustomTextField(
                                                                controller:
                                                                    textEditingControllers[
                                                                        index],
                                                                onChanged:
                                                                    (p0) {
                                                                  final ShowButtonBloc
                                                                      showButtonBloc =
                                                                      context.read<
                                                                          ShowButtonBloc>();
                                                                  mapControllerToFieldId(
                                                                      index,
                                                                      p0);

                                                                  if (benCustomerName.isEmpty ||
                                                                      benAddress
                                                                          .isEmpty ||
                                                                      benCity
                                                                          .isEmpty ||
                                                                      benMobileNo
                                                                          .isEmpty ||
                                                                      benSubBankCode
                                                                          .isEmpty ||
                                                                      benMobileNo
                                                                          .isEmpty) {
                                                                    allValid =
                                                                        false;
                                                                  } else {
                                                                    allValid =
                                                                        true;
                                                                  }
                                                                  log("allValid -> $allValid");

                                                                  log("benCustomerName -> $benCustomerName");
                                                                  log("benAddress -> $benAddress");
                                                                  log("benCity -> $benCity");

                                                                  mandatoryFilling =
                                                                      checkMandatoryFilling();
                                                                  log("mandatoryFilling -> $mandatoryFilling");

                                                                  showButtonBloc.add(
                                                                      const ShowButtonEvent(
                                                                          show:
                                                                              true));
                                                                },
                                                                borderColor: ((textEditingControllers[index].text.length > dynamicFields["dynamicFields"][index]["maxLength"] ||
                                                                            textEditingControllers[index].text.length <
                                                                                dynamicFields["dynamicFields"][index][
                                                                                    "minLength"]) &&
                                                                        textEditingControllers[index]
                                                                            .text
                                                                            .isNotEmpty &&
                                                                        dynamicFields["dynamicFields"][index]
                                                                            [
                                                                            "isManadatory"])
                                                                    ? AppColors
                                                                        .red100
                                                                    : const Color(
                                                                        0xFFEEEEEE),
                                                                hintText: dynamicFields["dynamicFields"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "placeholderText"] ??
                                                                    "${dynamicFields["dynamicFields"][index]["label"]} must be between ${dynamicFields["dynamicFields"][index]["minLength"]} and ${dynamicFields["dynamicFields"][index]["maxLength"]} characters",
                                                              );
                                                            },
                                                          )
                                                        : dynamicFields["dynamicFields"]
                                                                        [index]
                                                                    ["type"] ==
                                                                "Dropdown"
                                                            ? BlocBuilder<
                                                                DropdownSelectedBloc,
                                                                DropdownSelectedState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  return CustomDropDown(
                                                                    title: dynamicFields["dynamicFields"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "label"],
                                                                    items: dropDownLists[
                                                                        index],
                                                                    value: dynamicFields["dynamicFields"][index]["fieldId"] ==
                                                                            "BenIdType"
                                                                        ? idType
                                                                        : dynamicFields["dynamicFields"][index]["fieldId"] ==
                                                                                "RemittancePurpose"
                                                                            ? remittancePurpose
                                                                            : dynamicFields["dynamicFields"][index]["fieldId"] == "SourceOfFunds"
                                                                                ? sourceOfFunds
                                                                                : relation,
                                                                    onChanged:
                                                                        (value) {
                                                                      final ShowButtonBloc
                                                                          showButtonBloc =
                                                                          context
                                                                              .read<ShowButtonBloc>();
                                                                      if (remittancePurpose == null ||
                                                                          sourceOfFunds ==
                                                                              null ||
                                                                          relation ==
                                                                              null ||
                                                                          idType ==
                                                                              null) {
                                                                        mandatorySatisfiedCount++;
                                                                      }
                                                                      log("mandatorySatisfiedCount -> $mandatorySatisfiedCount");
                                                                      toggles[
                                                                          togglesAdded]++;
                                                                      mapDropdowntoFieldId(
                                                                          value,
                                                                          index);
                                                                      mandatoryFilling =
                                                                          checkMandatoryFilling();

                                                                      setState(
                                                                          () {});
                                                                      showButtonBloc.add(
                                                                          const ShowButtonEvent(
                                                                              show: true));
                                                                    },
                                                                  );
                                                                },
                                                              )
                                                            : const SizeBox(),
                                            BlocBuilder<ShowButtonBloc,
                                                ShowButtonState>(
                                              builder: (context, state) {
                                                if (((textEditingControllers[
                                                                    index]
                                                                .text
                                                                .length >
                                                            dynamicFields[
                                                                        "dynamicFields"]
                                                                    [index]
                                                                ["maxLength"] ||
                                                        textEditingControllers[
                                                                    index]
                                                                .text
                                                                .length <
                                                            dynamicFields[
                                                                        "dynamicFields"]
                                                                    [index][
                                                                "minLength"]) &&
                                                    textEditingControllers[index]
                                                        .text
                                                        .isNotEmpty &&
                                                    dynamicFields["dynamicFields"]
                                                            [index]
                                                        ["isManadatory"])) {
                                                  return Column(
                                                    children: [
                                                      const SizeBox(height: 7),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.error,
                                                            color: AppColors
                                                                .red100,
                                                            size: (12 /
                                                                    Dimensions
                                                                        .designWidth)
                                                                .w,
                                                          ),
                                                          const SizeBox(
                                                              width: 5),
                                                          Text(
                                                            "${dynamicFields["dynamicFields"][index]["label"]} must be between ${dynamicFields["dynamicFields"][index]["minLength"]} and ${dynamicFields["dynamicFields"][index]["maxLength"]} characters",
                                                            style: TextStyles
                                                                .primaryMedium
                                                                .copyWith(
                                                                    fontSize:
                                                                        (12 / Dimensions.designWidth)
                                                                            .w,
                                                                    color: AppColors
                                                                        .red100),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return const SizeBox();
                                                }
                                              },
                                            ),
                                            const SizeBox(height: 10),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        // ! Bank
                        : Expanded(
                            child: ListView.builder(
                              itemCount: dynamicFields["dynamicFields"]?.length,
                              itemBuilder: (context, index) {
                                // fieldIds.clear();
                                if (dynamicFields["dynamicFields"]?[index]
                                        ["isBank"] ==
                                    false) {
                                  return const SizeBox();
                                } else {
                                  if (widgetsBuilt ==
                                      dynamicFields["dynamicFields"]?.length) {
                                    widgetsBuilt = 0;
                                    textEditingControllersAdded = -1;
                                    togglesAdded = -1;
                                  }

                                  textEditingControllersAdded++;
                                  log("textEditingControllersAdded -> $textEditingControllersAdded");

                                  toggles.add(0);
                                  togglesAdded++;
                                  dropDownLists[index].clear();

                                  if (dynamicFields["dynamicFields"][index]
                                      ["isManadatory"]) {
                                    if (!(fieldIds.contains(
                                        dynamicFields["dynamicFields"][index]
                                            ["fieldId"]))) {
                                      fieldIds.add(
                                          dynamicFields["dynamicFields"][index]
                                              ["fieldId"]);

                                      log("fieldIds -> $fieldIds | length -> ${fieldIds.length}");

                                      populateFieldVariables();
                                      removeDuplicateVaribales(fieldVariables);
                                    }
                                  }

                                  if (dynamicFields["dynamicFields"][index]
                                          ["dropdownValues"] !=
                                      null) {
                                    jsonDecode(dynamicFields["dynamicFields"]
                                                [index]["dropdownValues"]
                                            .replaceAll('\\', ''))
                                        .forEach((key, value) =>
                                            dropDownLists[index].add(value));
                                  } else {}

                                  // }

                                  if (dynamicFields["dynamicFields"][index]
                                      ["isManadatory"]) {
                                    mandatoryFields++;

                                    widgetsBuilt++;
                                    log("widgetsBuilt -> $widgetsBuilt");
                                  }

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicFields["dynamicFields"]
                                                [index]["label"],
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              color: AppColors.dark80,
                                              fontSize:
                                                  (14 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          dynamicFields["dynamicFields"][index]
                                                  ["isManadatory"]
                                              ? const Asterisk()
                                              : const SizeBox(),
                                        ],
                                      ),
                                      const SizeBox(height: 7),
                                      dynamicFields["dynamicFields"][index]
                                                  ["type"] ==
                                              "Date"
                                          ? Ternary(
                                              condition: Platform.isIOS,
                                              truthy: SizedBox(
                                                  height: (100 /
                                                          Dimensions
                                                              .designHeight)
                                                      .h,
                                                  child: CupertinoDatePicker(
                                                    minimumDate: DateTime.now(),
                                                    initialDateTime:
                                                        DateTime.now(),
                                                    maximumDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: 365 * 10)),
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    onDateTimeChanged: (p0) {
                                                      final ShowButtonBloc
                                                          showButtonBloc =
                                                          context.read<
                                                              ShowButtonBloc>();
                                                      eidExpiryDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(p0);
                                                      log("eidExpiryDate -> $eidExpiryDate");
                                                      int fldIndx =
                                                          returnFieldIndex(
                                                              "BenIdExpiryDate");
                                                      fieldVariables[fldIndx] =
                                                          FieldVariables(
                                                              text:
                                                                  eidExpiryDate,
                                                              minLength: 0,
                                                              maxLength: 0);
                                                      // eidExpiryDate;

                                                      log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
                                                      mandatoryFilling =
                                                          checkMandatoryFilling();
                                                      log("mandatoryFilling -> $mandatoryFilling");
                                                      showButtonBloc.add(
                                                          const ShowButtonEvent(
                                                              show: true));
                                                    },
                                                  )),
                                              falsy: DatePickerWidget(
                                                looping: false,
                                                firstDate: DateTime.now(),
                                                initialDate: DateTime.now(),
                                                lastDate: DateTime.now().add(
                                                    const Duration(
                                                        days: 365 * 10)),
                                                dateFormat: "dd-MMMM-yyyy",
                                                onChange: (p0, _) {
                                                  final ShowButtonBloc
                                                      showButtonBloc =
                                                      context.read<
                                                          ShowButtonBloc>();
                                                  eidExpiryDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(p0);
                                                  log("eidExpiryDate -> $eidExpiryDate");
                                                  int fldIndx =
                                                      returnFieldIndex(
                                                          "BenIdExpiryDate");
                                                  fieldVariables[fldIndx] =
                                                      FieldVariables(
                                                          text: eidExpiryDate,
                                                          minLength: 0,
                                                          maxLength: 0);
                                                  log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
                                                  mandatoryFilling =
                                                      checkMandatoryFilling();
                                                  log("mandatoryFilling -> $mandatoryFilling");
                                                  showButtonBloc.add(
                                                      const ShowButtonEvent(
                                                          show: true));
                                                },
                                                pickerTheme:
                                                    DateTimePickerTheme(
                                                  dividerColor:
                                                      AppColors.dark30,
                                                  itemTextStyle: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: (20 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : dynamicFields["dynamicFields"]
                                                      [index]["type"] ==
                                                  "Mobile"
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: BlocBuilder<
                                                          ShowButtonBloc,
                                                          ShowButtonState>(
                                                        builder:
                                                            (context, state) {
                                                          return CustomTextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            controller:
                                                                textEditingControllers[
                                                                    index],
                                                            onChanged: (p0) {
                                                              final ShowButtonBloc
                                                                  showButtonBloc =
                                                                  context.read<
                                                                      ShowButtonBloc>();
                                                              mapControllerToFieldId(
                                                                  index, p0);

                                                              if (benBankName.isEmpty ||
                                                                  receiverAccountNumber
                                                                      .isEmpty ||
                                                                  benCustomerName
                                                                      .isEmpty ||
                                                                  benAddress
                                                                      .isEmpty ||
                                                                  benCity
                                                                      .isEmpty ||
                                                                  benMobileNo
                                                                      .isEmpty ||
                                                                  benBankCode
                                                                      .isEmpty ||
                                                                  benSubBankCode
                                                                      .isEmpty ||
                                                                  benMobileNo
                                                                      .isEmpty) {
                                                                allValid =
                                                                    false;
                                                              } else {
                                                                allValid = true;
                                                              }
                                                              log("allValid -> $allValid");
                                                              log("benBankName -> $benBankName");
                                                              log("receiverAccountNumber -> $receiverAccountNumber");
                                                              log("benCustomerName -> $benCustomerName");
                                                              log("benAddress -> $benAddress");
                                                              log("benCity -> $benCity");
                                                              mandatoryFilling =
                                                                  checkMandatoryFilling();
                                                              log("mandatoryFilling -> $mandatoryFilling");

                                                              showButtonBloc.add(
                                                                  const ShowButtonEvent(
                                                                      show:
                                                                          true));
                                                            },
                                                            borderColor: ((textEditingControllers[index].text.length >
                                                                            dynamicFields["dynamicFields"][index][
                                                                                "maxLength"] ||
                                                                        textEditingControllers[index].text.length <
                                                                            dynamicFields["dynamicFields"][index][
                                                                                "minLength"]) &&
                                                                    textEditingControllers[
                                                                            index]
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    dynamicFields[
                                                                            "dynamicFields"][index]
                                                                        [
                                                                        "isManadatory"])
                                                                ? AppColors
                                                                    .red100
                                                                : const Color(
                                                                    0xFFEEEEEE),
                                                            hintText: dynamicFields[
                                                                            "dynamicFields"]
                                                                        [index][
                                                                    "placeholderText"] ??
                                                                "${dynamicFields["dynamicFields"][index]["label"]} must be between ${dynamicFields["dynamicFields"][index]["minLength"]} and ${dynamicFields["dynamicFields"][index]["maxLength"]} characters",
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : dynamicFields["dynamicFields"]
                                                          [index]["type"] ==
                                                      "Text"
                                                  ? BlocBuilder<ShowButtonBloc,
                                                      ShowButtonState>(
                                                      builder:
                                                          (context, state) {
                                                        return CustomTextField(
                                                          controller:
                                                              textEditingControllers[
                                                                  index],
                                                          onChanged: (p0) {
                                                            final ShowButtonBloc
                                                                showButtonBloc =
                                                                context.read<
                                                                    ShowButtonBloc>();
                                                            mapControllerToFieldId(
                                                                index, p0);

                                                            if (benBankName.isEmpty ||
                                                                receiverAccountNumber
                                                                    .isEmpty ||
                                                                benCustomerName
                                                                    .isEmpty ||
                                                                benAddress
                                                                    .isEmpty ||
                                                                benCity
                                                                    .isEmpty ||
                                                                benMobileNo
                                                                    .isEmpty ||
                                                                benBankCode
                                                                    .isEmpty ||
                                                                benSubBankCode
                                                                    .isEmpty ||
                                                                benMobileNo
                                                                    .isEmpty) {
                                                              allValid = false;
                                                            } else {
                                                              allValid = true;
                                                            }
                                                            log("allValid -> $allValid");
                                                            log("benBankName -> $benBankName");
                                                            log("receiverAccountNumber -> $receiverAccountNumber");
                                                            log("benCustomerName -> $benCustomerName");
                                                            log("benAddress -> $benAddress");
                                                            log("benCity -> $benCity");

                                                            mandatoryFilling =
                                                                checkMandatoryFilling();
                                                            log("mandatoryFilling -> $mandatoryFilling");

                                                            showButtonBloc.add(
                                                                const ShowButtonEvent(
                                                                    show:
                                                                        true));
                                                          },
                                                          borderColor: ((textEditingControllers[index]
                                                                              .text
                                                                              .length >
                                                                          dynamicFields["dynamicFields"][index]
                                                                              [
                                                                              "maxLength"] ||
                                                                      textEditingControllers[index]
                                                                              .text
                                                                              .length <
                                                                          dynamicFields["dynamicFields"][index]
                                                                              [
                                                                              "minLength"]) &&
                                                                  textEditingControllers[index]
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  dynamicFields["dynamicFields"]
                                                                          [index]
                                                                      [
                                                                      "isManadatory"])
                                                              ? AppColors.red100
                                                              : const Color(
                                                                  0xFFEEEEEE),
                                                          hintText: dynamicFields[
                                                                          "dynamicFields"]
                                                                      [index][
                                                                  "placeholderText"] ??
                                                              "${dynamicFields["dynamicFields"][index]["label"]} must be between ${dynamicFields["dynamicFields"][index]["minLength"]} and ${dynamicFields["dynamicFields"][index]["maxLength"]} characters",
                                                        );
                                                      },
                                                    )
                                                  : dynamicFields["dynamicFields"]
                                                              [index]["type"] ==
                                                          "Dropdown"
                                                      ? BlocBuilder<
                                                          DropdownSelectedBloc,
                                                          DropdownSelectedState>(
                                                          builder:
                                                              (context, state) {
                                                            return CustomDropDown(
                                                              title: dynamicFields[
                                                                      "dynamicFields"]
                                                                  [
                                                                  index]["label"],
                                                              items:
                                                                  dropDownLists[
                                                                      index],
                                                              value: dynamicFields["dynamicFields"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "fieldId"] ==
                                                                      "BenIdType"
                                                                  ? idType
                                                                  : dynamicFields["dynamicFields"][index]
                                                                              [
                                                                              "fieldId"] ==
                                                                          "RemittancePurpose"
                                                                      ? remittancePurpose
                                                                      : dynamicFields["dynamicFields"][index]["fieldId"] ==
                                                                              "SourceOfFunds"
                                                                          ? sourceOfFunds
                                                                          : relation,
                                                              onChanged:
                                                                  (value) {
                                                                final ShowButtonBloc
                                                                    showButtonBloc =
                                                                    context.read<
                                                                        ShowButtonBloc>();
                                                                if (remittancePurpose == null ||
                                                                    sourceOfFunds ==
                                                                        null ||
                                                                    relation ==
                                                                        null ||
                                                                    idType ==
                                                                        null) {
                                                                  mandatorySatisfiedCount++;
                                                                }

                                                                log("mandatorySatisfiedCount -> $mandatorySatisfiedCount");
                                                                toggles[
                                                                    togglesAdded]++;
                                                                mapDropdowntoFieldId(
                                                                    value,
                                                                    index);
                                                                mandatoryFilling =
                                                                    checkMandatoryFilling();
                                                                log("mandatoryFilling -> $mandatoryFilling");

                                                                setState(() {});
                                                                showButtonBloc.add(
                                                                    const ShowButtonEvent(
                                                                        show:
                                                                            true));
                                                              },
                                                            );
                                                          },
                                                        )
                                                      : const SizeBox(),
                                      BlocBuilder<ShowButtonBloc,
                                          ShowButtonState>(
                                        builder: (context, state) {
                                          if (((textEditingControllers[index]
                                                          .text
                                                          .length >
                                                      dynamicFields[
                                                              "dynamicFields"][
                                                          index]["maxLength"] ||
                                                  textEditingControllers[index]
                                                          .text
                                                          .length <
                                                      dynamicFields[
                                                                  "dynamicFields"]
                                                              [index]
                                                          ["minLength"]) &&
                                              textEditingControllers[index]
                                                  .text
                                                  .isNotEmpty &&
                                              dynamicFields["dynamicFields"]
                                                  [index]["isManadatory"])) {
                                            return Column(
                                              children: [
                                                const SizeBox(height: 7),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.error,
                                                      color: AppColors.red100,
                                                      size: (12 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                    const SizeBox(width: 5),
                                                    Text(
                                                      "${dynamicFields["dynamicFields"][index]["label"]} must be between ${dynamicFields["dynamicFields"][index]["minLength"]} and ${dynamicFields["dynamicFields"][index]["maxLength"]} characters",
                                                      style: TextStyles
                                                          .primaryMedium
                                                          .copyWith(
                                                              fontSize: (12 /
                                                                      Dimensions
                                                                          .designWidth)
                                                                  .w,
                                                              color: AppColors
                                                                  .red100),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const SizeBox();
                                          }
                                        },
                                      ),
                                      const SizeBox(height: 10),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizeBox(height: 10),
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: (context, state) {
                        if (isChecked) {
                          return InkWell(
                            onTap: () {
                              isChecked = false;
                              isAddRemBeneficiary = isChecked;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
                              child: SvgPicture.asset(
                                ImageConstants.checkedBox,
                                width: (14 / Dimensions.designWidth).w,
                                height: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              isChecked = true;
                              isAddRemBeneficiary = isChecked;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
                              child: SvgPicture.asset(
                                ImageConstants.uncheckedBox,
                                width: (14 / Dimensions.designWidth).w,
                                height: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizeBox(width: 5),
                    Text(
                      labels[126]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isWalletSelected) {
                      if (isWalletSelectedd && mandatoryFilling) {
                        return GradientButton(
                          onTap: () async {
                            if (!isFetchingExchangeRate) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              isFetchingExchangeRate = true;
                              showButtonBloc.add(ShowButtonEvent(
                                  show: isFetchingExchangeRate));

                              var getExchRateApiResult =
                                  await MapExchangeRate.mapExchangeRate(
                                token ?? "",
                              );
                              log("getExchRateApiResult -> $getExchRateApiResult");

                              if (getExchRateApiResult["success"]) {
                                for (var fetchExchangeRate
                                    in getExchRateApiResult["fetchExRates"]) {
                                  if (fetchExchangeRate["exchangeCurrency"] ==
                                      receiverCurrency) {
                                    exchangeRate =
                                        fetchExchangeRate["exchangeRate"]
                                            .toDouble();
                                    log("exchangeRate -> $exchangeRate");
                                    fees = double.parse(
                                        fetchExchangeRate["transferFee"]
                                            .split(' ')
                                            .last);
                                    log("fees -> $fees");
                                    expectedTime =
                                        getExchRateApiResult["expectedTime"];
                                    break;
                                  }
                                }

                                if (context.mounted) {
                                  if (isChecked) {
                                    log("create beneficiary request -> ${{
                                      "beneficiaryType":
                                          !isBankSelected ? 5 : 2,
                                      "accountNumber":
                                          !isWalletSelected || benIdType == "2"
                                              ? receiverAccountNumber
                                              : walletNumber.isEmpty
                                                  ? benMobileNo
                                                  : walletNumber,
                                      "name": benCustomerName,
                                      "address": benAddress,
                                      "accountType": benAccountType,
                                      "swiftReference": 0,
                                      "targetCurrency": receiverCurrency,
                                      "countryCode": beneficiaryCountryCode,
                                      "benBankCode": benBankCode,
                                      "benMobileNo": benMobileNo,
                                      "benSubBankCode": benSubBankCode,
                                      "benIdType": benIdType,
                                      "benIdNo": benIdNo,
                                      "benIdExpiryDate": benIdExpiryDate,
                                      "benBankName": benBankName,
                                      "benSwiftCodeText": benSwiftCode,
                                      "city": benCity,
                                      "remittancePurpose":
                                          remittancePurpose ?? "",
                                      "sourceOfFunds": sourceOfFunds ?? "",
                                      "relation": relation ?? "",
                                      "providerName": providerName ?? "",
                                      "isBusinessTransfer": isBusinessTransfer,
                                    }}");

                                    var createBeneficiaryAPiResult =
                                        await MapCreateBeneficiary
                                            .mapCreateBeneficiary(
                                      {
                                        "beneficiaryType":
                                            !isBankSelected ? 5 : 2,
                                        "accountNumber": !isWalletSelected ||
                                                benIdType == "2"
                                            ? receiverAccountNumber
                                            : walletNumber.isEmpty
                                                ? benMobileNo
                                                : walletNumber,
                                        "name": benCustomerName,
                                        "address": benAddress,
                                        "accountType": benAccountType,
                                        "swiftReference": 0,
                                        "targetCurrency": receiverCurrency,
                                        "countryCode": beneficiaryCountryCode,
                                        "benBankCode": benBankCode,
                                        "benMobileNo": benMobileNo,
                                        "benSubBankCode": benSubBankCode,
                                        "benIdType": benIdType,
                                        "benIdNo": benIdNo,
                                        "benIdExpiryDate": benIdExpiryDate,
                                        "benBankName": benBankName,
                                        "benSwiftCodeText": benSwiftCode,
                                        "city": benCity,
                                        "remittancePurpose":
                                            remittancePurpose ?? "",
                                        "sourceOfFunds": sourceOfFunds ?? "",
                                        "relation": relation ?? "",
                                        "providerName": providerName ?? "",
                                        "isBusinessTransfer":
                                            isBusinessTransfer,
                                      },
                                      token ?? "",
                                    );

                                    log("createBeneficiaryAPiResult -> $createBeneficiaryAPiResult");

                                    if (createBeneficiaryAPiResult["success"]) {
                                      if (context.mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.selectRecipient,
                                          arguments: SendMoneyArgumentModel(
                                            isBetweenAccounts: false,
                                            isWithinDhabi: false,
                                            isRemittance: true,
                                            isRetail:
                                                sendMoneyArgument.isRetail,
                                          ).toMap(),
                                          (route) => false,
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return CustomDialog(
                                              svgAssetPath:
                                                  ImageConstants.warning,
                                              title: "Sorry",
                                              message: createBeneficiaryAPiResult[
                                                      "message"] ??
                                                  "There was an error adding the beneficiary, please try again later.",
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
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.transferAmount,
                                      arguments: SendMoneyArgumentModel(
                                        isBetweenAccounts:
                                            sendMoneyArgument.isBetweenAccounts,
                                        isWithinDhabi:
                                            sendMoneyArgument.isWithinDhabi,
                                        isRemittance:
                                            sendMoneyArgument.isRemittance,
                                        isRetail: sendMoneyArgument.isRetail,
                                      ).toMap(),
                                    );
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry!",
                                        message: getExchRateApiResult[
                                                "message"] ??
                                            "There was an error fetching exchange rate, please try again later.",
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

                              isFetchingExchangeRate = false;
                              showButtonBloc.add(ShowButtonEvent(
                                  show: isFetchingExchangeRate));
                            }
                          },
                          text: labels[127]["labelText"],
                          auxWidget: isFetchingExchangeRate
                              ? const LoaderRow()
                              : const SizeBox(),
                        );
                      } else {
                        return SolidButton(
                          onTap: () {},
                          text: labels[127]["labelText"],
                        );
                      }
                    } else {
                      if (mandatoryFilling) {
                        return GradientButton(
                          onTap: () async {
                            if (!isFetchingExchangeRate) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              isFetchingExchangeRate = true;
                              showButtonBloc.add(ShowButtonEvent(
                                  show: isFetchingExchangeRate));

                              var getExchRateApiResult =
                                  await MapExchangeRate.mapExchangeRate(
                                token ?? "",
                              );
                              log("getExchRateApiResult -> $getExchRateApiResult");

                              if (getExchRateApiResult["success"]) {
                                for (var fetchExchangeRate
                                    in getExchRateApiResult["fetchExRates"]) {
                                  if (fetchExchangeRate["exchangeCurrency"] ==
                                      receiverCurrency) {
                                    exchangeRate =
                                        fetchExchangeRate["exchangeRate"]
                                            .toDouble();
                                    log("exchangeRate -> $exchangeRate");
                                    fees = double.parse(
                                        fetchExchangeRate["transferFee"]
                                            .split(' ')
                                            .last);
                                    log("fees -> $fees");
                                    expectedTime =
                                        getExchRateApiResult["expectedTime"];
                                    break;
                                  }
                                }

                                if (context.mounted) {
                                  if (isChecked) {
                                    log("create beneficiary request -> ${{
                                      "beneficiaryType":
                                          !isBankSelected ? 5 : 2,
                                      "accountNumber":
                                          !isWalletSelected || benIdType == "2"
                                              ? receiverAccountNumber
                                              : walletNumber.isEmpty
                                                  ? benMobileNo
                                                  : walletNumber,
                                      "name": benCustomerName,
                                      "address": benAddress,
                                      "accountType": benAccountType,
                                      "swiftReference": 0,
                                      "targetCurrency": receiverCurrency,
                                      "countryCode": beneficiaryCountryCode,
                                      "benBankCode": benBankCode,
                                      "benMobileNo": benMobileNo,
                                      "benSubBankCode": benSubBankCode,
                                      "benIdType": benIdType,
                                      "benIdNo": benIdNo,
                                      "benIdExpiryDate": benIdExpiryDate,
                                      "benBankName": benBankName,
                                      "benSwiftCodeText": benSwiftCode,
                                      "city": benCity,
                                      "remittancePurpose":
                                          remittancePurpose ?? "",
                                      "sourceOfFunds": sourceOfFunds ?? "",
                                      "relation": relation ?? "",
                                      "providerName": providerName ?? "",
                                      "isBusinessTransfer": isBusinessTransfer,
                                    }}");

                                    var createBeneficiaryAPiResult =
                                        await MapCreateBeneficiary
                                            .mapCreateBeneficiary(
                                      {
                                        "beneficiaryType":
                                            !isBankSelected ? 5 : 2,
                                        "accountNumber": !isWalletSelected ||
                                                benIdType == "2"
                                            ? receiverAccountNumber
                                            : walletNumber.isEmpty
                                                ? benMobileNo
                                                : walletNumber,
                                        "name": benCustomerName,
                                        "address": benAddress,
                                        "accountType": benAccountType,
                                        "swiftReference": 0,
                                        "targetCurrency": receiverCurrency,
                                        "countryCode": beneficiaryCountryCode,
                                        "benBankCode": benBankCode,
                                        "benMobileNo": benMobileNo,
                                        "benSubBankCode": benSubBankCode,
                                        "benIdType": benIdType,
                                        "benIdNo": benIdNo,
                                        "benIdExpiryDate": benIdExpiryDate,
                                        "benBankName": benBankName,
                                        "benSwiftCodeText": benSwiftCode,
                                        "city": benCity,
                                        "remittancePurpose":
                                            remittancePurpose ?? "",
                                        "sourceOfFunds": sourceOfFunds ?? "",
                                        "relation": relation ?? "",
                                        "providerName": providerName ?? "",
                                        "isBusinessTransfer":
                                            isBusinessTransfer,
                                      },
                                      token ?? "",
                                    );

                                    log("createBeneficiaryAPiResult -> $createBeneficiaryAPiResult");

                                    if (createBeneficiaryAPiResult["success"]) {
                                      if (context.mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.selectRecipient,
                                          arguments: SendMoneyArgumentModel(
                                            isBetweenAccounts: false,
                                            isWithinDhabi: false,
                                            isRemittance: true,
                                            isRetail:
                                                sendMoneyArgument.isRetail,
                                          ).toMap(),
                                          (route) => false,
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return CustomDialog(
                                              svgAssetPath:
                                                  ImageConstants.warning,
                                              title: "Sorry",
                                              message: createBeneficiaryAPiResult[
                                                      "message"] ??
                                                  "There was an error adding the beneficiary, please try again later.",
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
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.transferAmount,
                                      arguments: SendMoneyArgumentModel(
                                        isBetweenAccounts:
                                            sendMoneyArgument.isBetweenAccounts,
                                        isWithinDhabi:
                                            sendMoneyArgument.isWithinDhabi,
                                        isRemittance:
                                            sendMoneyArgument.isRemittance,
                                        isRetail: sendMoneyArgument.isRetail,
                                      ).toMap(),
                                    );
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry!",
                                        message: getExchRateApiResult[
                                                "message"] ??
                                            "There was an error fetching exchange rate, please try again later.",
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

                              isFetchingExchangeRate = false;
                              showButtonBloc.add(ShowButtonEvent(
                                  show: isFetchingExchangeRate));
                            }
                          },
                          text: labels[127]["labelText"],
                          auxWidget: isFetchingExchangeRate
                              ? const LoaderRow()
                              : const SizeBox(),
                        );
                      } else {
                        return SolidButton(
                          onTap: () {},
                          text: labels[127]["labelText"],
                        );
                      }
                    }
                  },
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void mapControllerToFieldId(int indx, String p0) {
    int fldIndx = -1;
    switch (dynamicFields["dynamicFields"][indx]["fieldId"]) {
      case "BenBankName":
        fldIndx = returnFieldIndex("BenBankName");
        benBankName = p0.trim();
        benBankNameMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benBankNameMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benBankName,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benBankName -> $benBankName");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");

        break;
      case "BenAccountNo":
        fldIndx = returnFieldIndex("BenAccountNo");
        receiverAccountNumber = p0.trim();
        benAccountMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benAccountMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: receiverAccountNumber,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("receiverAccountNumber -> $receiverAccountNumber");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");

        break;
      case "BenBankCode":
        fldIndx = returnFieldIndex("BenBankCode");
        benBankCode = p0.trim();
        benBankCodeMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benBankCodeMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benBankCode,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benBankCode -> $benBankCode");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "BenSubBankCode":
        fldIndx = returnFieldIndex("BenSubBankCode");
        benSubBankCode = p0.trim();
        benSubBankCodeMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benSubBankCodeMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benSubBankCode,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benSubBankCode -> $benSubBankCode");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "BenMobileNo":
        fldIndx = returnFieldIndex("BenMobileNo");
        benMobileNo = p0.trim();
        benMobileNoMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benMobileNoMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benMobileNo,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benMobileNo -> $benMobileNo");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "BenWalletNumber":
        fldIndx = returnFieldIndex("BenWalletNumber");
        walletNumber = p0.trim();
        walletNumberMin = dynamicFields["dynamicFields"][indx]["minLength"];
        walletNumberMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: walletNumber,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("walletNumber -> $walletNumber");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "BenCustomerName":
        fldIndx = returnFieldIndex("BenCustomerName");
        benCustomerName = p0.trim();
        benCustomerNameMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benCustomerNameMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benCustomerName,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benCustomerName -> $benCustomerName");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "Address":
        fldIndx = returnFieldIndex("Address");
        benAddress = p0.trim();
        benAddressMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benAddressMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benAddress,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benAddress -> $benAddress");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "City":
        fldIndx = returnFieldIndex("City");
        benCity = p0.trim();
        benCityMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benCityMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benCity,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benCity -> $benCity");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "SwiftCode":
        fldIndx = returnFieldIndex("SwiftCode");
        benSwiftCode = p0.trim();
        benSwiftCodeMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benSwiftCodeMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benSwiftCode,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benSwiftCode -> $benSwiftCode");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "BenIdNo":
        fldIndx = returnFieldIndex("BenIdNo");
        benIdNo = p0.trim();
        benIdNoMin = dynamicFields["dynamicFields"][indx]["minLength"];
        benIdNoMax = dynamicFields["dynamicFields"][indx]["maxLength"];
        fieldVariables[fldIndx] = FieldVariables(
          text: benIdNo,
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("benIdNo -> $benIdNo");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      default:
    }
  }

  void mapDropdowntoFieldId(Object? val, int indx) {
    int fldIndx = -1;
    switch (dynamicFields["dynamicFields"][indx]["fieldId"]) {
      case "RemittancePurpose":
        fldIndx = returnFieldIndex("RemittancePurpose");
        remittancePurpose = val as String;
        fieldVariables[fldIndx] = FieldVariables(
          text: remittancePurpose ?? "",
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("remittancePurpose -> $remittancePurpose");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "SourceOfFunds":
        fldIndx = returnFieldIndex("SourceOfFunds");
        sourceOfFunds = val as String;
        fieldVariables[fldIndx] = FieldVariables(
          text: sourceOfFunds ?? "",
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("sourceOfFunds -> $sourceOfFunds");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "Relation":
        fldIndx = returnFieldIndex("Relation");
        relation = val as String;
        fieldVariables[fldIndx] = FieldVariables(
          text: relation ?? "",
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("relation -> $relation");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      case "BenIdType":
        fldIndx = returnFieldIndex("BenIdType");
        idType = val as String;
        fieldVariables[fldIndx] = FieldVariables(
          text: idType ?? "",
          minLength: dynamicFields["dynamicFields"][indx]["minLength"],
          maxLength: dynamicFields["dynamicFields"][indx]["maxLength"],
        );

        log("idType -> $idType");
        log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
        break;
      default:
    }
  }

  void populateFieldVariables() {
    fieldVariables.clear();
    for (var i = 0; i < fieldIds.length; i++) {
      if (fieldIds[i] == "BenBankName") {
        fieldVariables.add(FieldVariables(
            text: benBankName,
            minLength: benBankNameMin,
            maxLength: benBankNameMax));
      } else if (fieldIds[i] == "BenAccountNo") {
        fieldVariables.add(FieldVariables(
            text: receiverAccountNumber,
            minLength: benAccountMin,
            maxLength: benAccountMax));
      } else if (fieldIds[i] == "BenCustomerName") {
        fieldVariables.add(FieldVariables(
            text: benCustomerName,
            minLength: benCustomerNameMin,
            maxLength: benCustomerNameMax));
      } else if (fieldIds[i] == "Address") {
        fieldVariables.add(FieldVariables(
            text: benAddress,
            minLength: benAddressMin,
            maxLength: benAddressMax));
      } else if (fieldIds[i] == "City") {
        fieldVariables.add(FieldVariables(
            text: benCity, minLength: benCityMin, maxLength: benCityMax));
      } else if (fieldIds[i] == "BenMobileNo") {
        if (isWalletSelected) {
          fieldVariables.add(FieldVariables(
              text: walletNumber,
              minLength: benMobileNoMin,
              maxLength: benMobileNoMax));
        } else {
          fieldVariables.add(FieldVariables(
              text: benMobileNo,
              minLength: benMobileNoMin,
              maxLength: benMobileNoMax));
        }
      } else if (fieldIds[i] == "BenSubBankCode") {
        fieldVariables.add(FieldVariables(
            text: benSubBankCode,
            minLength: benSubBankCodeMin,
            maxLength: benSubBankCodeMax));
      } else if (fieldIds[i] == "BenBankCode") {
        fieldVariables.add(FieldVariables(
            text: benBankCode,
            minLength: benBankCodeMin,
            maxLength: benBankCodeMax));
      } else if (fieldIds[i] == "RemittancePurpose") {
        fieldVariables.add(FieldVariables(
            text: remittancePurpose ?? "", minLength: 0, maxLength: 0));
      } else if (fieldIds[i] == "SourceOfFunds") {
        fieldVariables.add(FieldVariables(
            text: sourceOfFunds ?? "", minLength: 0, maxLength: 0));
      } else if (fieldIds[i] == "Relation") {
        fieldVariables.add(
            FieldVariables(text: relation ?? "", minLength: 0, maxLength: 0));
      } else if (fieldIds[i] == "BenIdType") {
        fieldVariables.add(
            FieldVariables(text: idType ?? "", minLength: 0, maxLength: 0));
      } else if (fieldIds[i] == "BenIdNo") {
        fieldVariables.add(FieldVariables(
            text: benIdNo, minLength: benIdNoMin, maxLength: benIdNoMax));
      } else if (fieldIds[i] == "BenIdExpiryDate") {
        fieldVariables.add(
            FieldVariables(text: benIdExpiryDate, minLength: 1, maxLength: 20));
      }
    }
    log("fieldVariables -> $fieldVariables | length -> ${fieldVariables.length}");
  }

  int returnFieldIndex(String fieldID) {
    for (var i = 0; i < fieldIds.length; i++) {
      if (fieldID == fieldIds[i]) {
        return i;
      }
    }
    return -1;
  }

  void removeDuplicateVaribales(List originalList) {
    originalList.toSet().toList();
  }

  void updateVariableListValue(String label, String updatedValue) {}

  bool checkMandatoryFilling() {
    for (var i = 0; i < fieldVariables.length; i++) {
      if (fieldVariables[i].maxLength == 0) {
        if (fieldVariables[i].text.trim() == "") {
          return false;
        }
      } else {
        if (fieldVariables[i].text.trim().length <
                fieldVariables[i].minLength ||
            fieldVariables[i].text.trim().length >
                fieldVariables[i].maxLength) {
          return false;
        }
      }
    }

    return true;
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  @override
  void dispose() {
    remittancePurpose = null;
    sourceOfFunds = null;
    relation = null;
    idType = null;
    super.dispose();
  }
}

class FieldVariables {
  final String text;
  final int minLength;
  final int maxLength;
  FieldVariables({
    required this.text,
    required this.minLength,
    required this.maxLength,
  });

  FieldVariables copyWith({
    String? text,
    int? minLength,
    int? maxLength,
  }) {
    return FieldVariables(
      text: text ?? this.text,
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'minLength': minLength,
      'maxLength': maxLength,
    };
  }

  factory FieldVariables.fromMap(Map<String, dynamic> map) {
    return FieldVariables(
      text: map['text'] as String,
      minLength: map['minLength'] as int,
      maxLength: map['maxLength'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory FieldVariables.fromJson(String source) =>
      FieldVariables.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FieldVariables(text: $text, minLength: $minLength, maxLength: $maxLength)';

  @override
  bool operator ==(covariant FieldVariables other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.minLength == minLength &&
        other.maxLength == maxLength;
  }

  @override
  int get hashCode => text.hashCode ^ minLength.hashCode ^ maxLength.hashCode;
}
