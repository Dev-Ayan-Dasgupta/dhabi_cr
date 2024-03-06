// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class DepositBeneficiaryScreen extends StatefulWidget {
  const DepositBeneficiaryScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<DepositBeneficiaryScreen> createState() =>
      _DepositBeneficiaryScreenState();
}

class _DepositBeneficiaryScreenState extends State<DepositBeneficiaryScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();

  bool isFirstName = false;
  bool isLastName = false;
  bool isAddress = false;
  bool isIban = false;

  String? selectedBank;
  bool isSwiftSelected = false;
  int swiftReference = 0;
  int beneficiaryAccountType = 0;
  String? selectedAccType;
  bool isAccountTypeSelected = false;
  String? selectedReason;
  String? reasonCode;
  bool isReasonSelected = false;

  int toggles = 0;

  bool isChecked = false;

  late DepositConfirmationArgumentModel depositConfirmation;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    depositConfirmation = DepositConfirmationArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
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
                    "Transfer Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "First Name",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            controller: _firstNameController,
                            onChanged: (p0) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              if (_firstNameController.text.isEmpty) {
                                isFirstName = false;
                              } else {
                                isFirstName = true;
                              }
                              showButtonBloc
                                  .add(ShowButtonEvent(show: isFirstName));
                            },
                            hintText: "Enter your first name",
                          ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "Last Name",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            controller: _lastNameController,
                            onChanged: (p0) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              if (_lastNameController.text.isEmpty) {
                                isLastName = false;
                              } else {
                                isLastName = true;
                              }
                              showButtonBloc
                                  .add(ShowButtonEvent(show: isLastName));
                            },
                            hintText: "Enter your last name",
                          ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "Address",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            controller: _addressController,
                            onChanged: (p0) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              if (_addressController.text.isEmpty) {
                                isAddress = false;
                              } else {
                                isAddress = true;
                              }
                              showButtonBloc
                                  .add(ShowButtonEvent(show: isAddress));
                            },
                            hintText: "Enter your address",
                          ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "IBAN / Account Number",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          CustomTextField(
                            controller: _ibanController,
                            onChanged: (p0) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              if (_ibanController.text.isEmpty) {
                                isIban = false;
                              } else {
                                isIban = true;
                              }
                              showButtonBloc.add(ShowButtonEvent(show: isIban));
                            },
                            hintText: "Enter your IBAN",
                          ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "Account Type",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          BlocBuilder<DropdownSelectedBloc,
                              DropdownSelectedState>(
                            builder: buildAccountTypeDropdown,
                          ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "BIC / SWIFT Code",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          BlocBuilder<DropdownSelectedBloc,
                              DropdownSelectedState>(
                            builder: buildSwiftDropdown,
                          ),
                          const SizeBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "Reason for Sending",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 10),
                          BlocBuilder<DropdownSelectedBloc,
                              DropdownSelectedState>(
                            builder: buildReasonDropdown,
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
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: buildCheckBox,
                    ),
                    const SizeBox(width: 5),
                    Text(
                      'Add this person to my recipient list',
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark50,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
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
    );
  }

  Widget buildSwiftDropdown(BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc incomeSourceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return CustomDropDown(
      title: "Select Bank",
      items: bankNames,
      value: selectedBank,
      onChanged: (value) {
        final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
        toggles++;
        isSwiftSelected = true;
        selectedBank = value as String;
        for (var bank in banks) {
          if (bank["displayName"] == selectedBank) {
            swiftReference = bank["swiftReference"];
            break;
          }
        }
        log("swiftReference -> $swiftReference");
        incomeSourceSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isSwiftSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(ShowButtonEvent(show: isSwiftSelected));
      },
    );
  }

  Widget buildReasonDropdown(
      BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc incomeSourceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return CustomDropDown(
      title: "Select Reason",
      items: reasonOfSending,
      value: selectedReason,
      onChanged: (value) {
        final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
        toggles++;
        isReasonSelected = true;
        selectedReason = value as String;
        for (int i = 0; i < allDDs[9]["items"].length; i++) {
          if (allDDs[9]["items"][i]["value"] == selectedReason) {
            reasonCode = allDDs[9]["items"][i]["key"].substring(
                allDDs[9]["items"][i]["key"].length - 3,
                allDDs[9]["items"][i]["key"].length);
            break;
          }
        }
        log("reasonCode -> $reasonCode");
        incomeSourceSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isReasonSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(ShowButtonEvent(show: isReasonSelected));
      },
    );
  }

  Widget buildAccountTypeDropdown(
      BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc incomeSourceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return CustomDropDown(
      title: "Select Reason",
      items: typeOfAccountDDs,
      value: selectedAccType,
      onChanged: (value) {
        final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
        toggles++;
        isAccountTypeSelected = true;
        selectedAccType = value as String;
        selectedAccType == "Current Account"
            ? beneficiaryAccountType = 2
            : beneficiaryAccountType = 1;
        incomeSourceSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isAccountTypeSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(ShowButtonEvent(show: isAccountTypeSelected));
      },
    );
  }

  Widget buildCheckBox(BuildContext context, CheckBoxState state) {
    final showButtonBloc = context.read<ShowButtonBloc>();
    if (isChecked) {
      return InkWell(
        onTap: () {
          isChecked = false;
          triggerCheckBoxEvent(isChecked);
          showButtonBloc.add(ShowButtonEvent(show: isChecked));
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
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
          triggerCheckBoxEvent(isChecked);
          showButtonBloc.add(ShowButtonEvent(show: isChecked));
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    }
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (!isFirstName ||
        !isLastName ||
        !isAddress ||
        !isIban ||
        !isSwiftSelected ||
        !isAccountTypeSelected ||
        !isReasonSelected) {
      return SolidButton(onTap: () {}, text: labels[31]["labelText"]);
    } else {
      return GradientButton(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.depositConfirmation,
            arguments: DepositConfirmationArgumentModel(
              isRetail: depositConfirmation.isRetail,
              currency: depositConfirmation.currency,
              accountNumber: depositConfirmation.accountNumber,
              depositAmount: depositConfirmation.depositAmount,
              tenureDays: depositConfirmation.tenureDays,
              interestRate: depositConfirmation.interestRate,
              interestAmount: depositConfirmation.interestAmount,
              interestPayout: depositConfirmation.interestPayout,
              isAutoRenewal: depositConfirmation.isAutoRenewal,
              isAutoTransfer: true,
              creditAccountNumber: _ibanController.text,
              dateOfMaturity: depositConfirmation.dateOfMaturity,
              depositBeneficiary: DepositBeneficiaryModel(
                accountNumber: _ibanController.text,
                name:
                    "${_firstNameController.text} ${_lastNameController.text}",
                address: _addressController.text,
                accountType: beneficiaryAccountType,
                swiftReference: swiftReference,
                reasonForSending: reasonCode ?? "",
                saveBeneficiary: isChecked,
              ),
            ).toMap(),
          );
        },
        text: labels[31]["labelText"],
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _ibanController.dispose();
    super.dispose();
  }
}
