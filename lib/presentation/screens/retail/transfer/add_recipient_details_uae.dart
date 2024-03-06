import 'package:dialup_mobile_app/bloc/checkBox/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddRecipientDetailsUaeScreen extends StatefulWidget {
  const AddRecipientDetailsUaeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipientDetailsUaeScreen> createState() =>
      _AddRecipientDetailsUaeScreenState();
}

class _AddRecipientDetailsUaeScreenState
    extends State<AddRecipientDetailsUaeScreen> {
  bool isChecked = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8'
  ];

  int toggles = 0;

  String? selectedAccType;
  String? selectedBank;
  String? selectedReason;

  bool isName = false;
  bool isAccountTypeSelected = false;
  bool isIban = false;
  bool isBankNameSelected = false;
  bool isReasonSelected = false;

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
                    "Add Recipient Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Full Name",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.red100,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 7),
                        CustomTextField(
                          hintText: "e.g., Muhammad Al Mansour",
                          controller: _nameController,
                          onChanged: onNameChanged,
                        ),
                        const SizeBox(height: 15),
                        Text(
                          labels[195]["labelText"],
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.red100,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 7),
                        BlocBuilder<DropdownSelectedBloc,
                            DropdownSelectedState>(
                          builder: buildAccountType,
                        ),
                        const SizeBox(height: 15),
                        Text(
                          "IBAN / CC Number",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.red100,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 7),
                        CustomTextField(
                          hintText: "Enter IBAN / Credit Card Number",
                          keyboardType: TextInputType.number,
                          controller: _ibanController,
                          onChanged: onIbanChanged,
                        ),
                        const SizeBox(height: 15),
                        Text(
                          "Bank Name / Card Issuer",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.red100,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 7),
                        BlocBuilder<DropdownSelectedBloc,
                            DropdownSelectedState>(
                          builder: buildBankName,
                        ),
                        const SizeBox(height: 15),
                        Text(
                          "Purpose of Payment",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.red100,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 7),
                        BlocBuilder<DropdownSelectedBloc,
                            DropdownSelectedState>(
                          builder: buildPurpose,
                        ),
                        const SizeBox(height: 20),
                      ],
                    ),
                  ))
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

  void onNameChanged(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (p0.isEmpty) {
      isName = false;
    } else {
      isName = true;
    }
    showButtonBloc.add(
      ShowButtonEvent(
        show: isName &&
            isIban &&
            isAccountTypeSelected &&
            isBankNameSelected &&
            isReasonSelected,
      ),
    );
  }

  Widget buildAccountType(BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc accountTypeBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomDropDown(
      title: "e.g., Savings",
      items: items,
      value: selectedAccType,
      onChanged: (value) {
        toggles++;
        isAccountTypeSelected = true;
        selectedAccType = value as String;
        accountTypeBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isAccountTypeSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(
          ShowButtonEvent(
            show: isName &&
                isIban &&
                isAccountTypeSelected &&
                isBankNameSelected &&
                isReasonSelected,
          ),
        );
      },
    );
  }

  void onIbanChanged(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (p0.isEmpty) {
      isIban = false;
    } else {
      isIban = true;
    }
    showButtonBloc.add(
      ShowButtonEvent(
        show: isName &&
            isIban &&
            isAccountTypeSelected &&
            isBankNameSelected &&
            isReasonSelected,
      ),
    );
  }

  Widget buildBankName(BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc bankNameBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomDropDown(
      title: "Name of Recipients Bank",
      items: items,
      value: selectedBank,
      onChanged: (value) {
        toggles++;
        isBankNameSelected = true;
        selectedBank = value as String;
        bankNameBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isBankNameSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(
          ShowButtonEvent(
            show: isName &&
                isIban &&
                isAccountTypeSelected &&
                isBankNameSelected &&
                isReasonSelected,
          ),
        );
      },
    );
  }

  Widget buildPurpose(BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc reasonTypeBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomDropDown(
      title: "e.g., Family Support",
      items: items,
      value: selectedReason,
      onChanged: (value) {
        toggles++;
        isReasonSelected = true;
        selectedReason = value as String;
        reasonTypeBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isReasonSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(
          ShowButtonEvent(
            show: isName &&
                isIban &&
                isAccountTypeSelected &&
                isBankNameSelected &&
                isReasonSelected,
          ),
        );
      },
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isName &&
        isIban &&
        isAccountTypeSelected &&
        isBankNameSelected &&
        isReasonSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                },
              ),
              const SizeBox(width: 5),
              Text(
                "Add this person to my recipient list",
                style: TextStyles.primaryMedium.copyWith(
                  color: const Color(0XFF414141),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
          const SizeBox(height: 10),
          GradientButton(
            onTap: () {},
            text: labels[127]["labelText"],
          ),
          const SizeBox(height: 20),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ibanController.dispose();
    super.dispose();
  }
}
