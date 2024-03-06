import 'dart:developer';

import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/services/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class RequestTypeScreen extends StatefulWidget {
  const RequestTypeScreen({Key? key}) : super(key: key);

  @override
  State<RequestTypeScreen> createState() => _RequestTypeScreenState();
}

class _RequestTypeScreenState extends State<RequestTypeScreen> {
  final TextEditingController _remarkController = TextEditingController();

  String? selectedRequest;
  int selectedRequestIndex = -1;

  String? selectedLoanNumber;
  String? selectedAccountNumber;
  String? selectedDepositNumber;

  int toggles = 0;
  bool isRequestTypeSelected = false;
  bool isRemarkValid = false;
  bool isNumberSelected = false;
  bool isLoanNumberSelected = false;
  bool isAccountNumberSelected = false;
  bool isDepositNumberSelected = false;

  bool isRequesting = false;

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
                    labels[56]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        labels[56]["labelText"],
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: buildDropdownRequestType,
                  ),
                  // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  //   builder: (context, state) {
                  //     return Ternary(
                  //       condition: selectedRequestIndex >= 1 &&
                  //           selectedRequestIndex <= 4,
                  //       truthy: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const SizeBox(height: 20),
                  //           Row(
                  //             children: [
                  //               Text(
                  //                 selectedRequestIndex == 1 ||
                  //                         selectedRequestIndex == 2
                  //                     ? "Loan Number"
                  //                     : selectedRequestIndex == 3
                  //                         ? "Fixed Deposit Number"
                  //                         : "Account Number",
                  //                 style: TextStyles.primary.copyWith(
                  //                   color: AppColors.dark80,
                  //                   fontSize: (14 / Dimensions.designWidth).w,
                  //                 ),
                  //               ),
                  //               const Asterisk(),
                  //             ],
                  //           ),
                  //           const SizeBox(height: 10),
                  //           BlocBuilder<DropdownSelectedBloc,
                  //               DropdownSelectedState>(
                  //             builder: selectedRequestIndex == 1 ||
                  //                     selectedRequestIndex == 2
                  //                 ? buildDropdownLoanNumber
                  //                 : selectedRequestIndex == 3
                  //                     ? buildDropdownDepositsNumber
                  //                     : buildDropdownAccountNumber,
                  //           ),
                  //         ],
                  //       ),
                  //       falsy: const SizeBox(),
                  //     );
                  //   },
                  // ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        labels[58]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildRemarks,
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

  Widget buildDropdownRequestType(
      BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomDropDown(
      title: "Select from the list",
      items: serviceRequestDDs,
      value: selectedRequest,
      onChanged: (value) {
        toggles++;
        isRequestTypeSelected = true;
        selectedRequest = value as String;
        for (int i = 0; i < serviceRequestDDs.length; i++) {
          if (allDDs[0]["items"][i]["value"] == selectedRequest) {
            selectedRequestIndex = i;
            log("selectedRequestIndex -> $selectedRequestIndex");
            break;
          }
        }
        // if (!(selectedRequestIndex >= 1 && selectedRequestIndex <= 4)) {
        //   isNumberSelected = true;
        // } else {
        //   isNumberSelected = false;
        // }
        dropdownSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isRequestTypeSelected,
            toggles: toggles,
          ),
        );
        showButtonBloc.add(
          ShowButtonEvent(show: isRequestTypeSelected && isRemarkValid),
        );
      },
    );
  }

  // Widget buildDropdownLoanNumber(
  //     BuildContext context, DropdownSelectedState state) {
  //   final DropdownSelectedBloc dropdownSelectedBloc =
  //       context.read<DropdownSelectedBloc>();
  //   final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
  //   return CustomDropDown(
  //     title: "Select from the list",
  //     items: loanAccountNumbers,
  //     value: selectedLoanNumber,
  //     onChanged: (value) {
  //       toggles++;
  //       isLoanNumberSelected = true;
  //       selectedLoanNumber = value as String;
  //       dropdownSelectedBloc.add(
  //         DropdownSelectedEvent(
  //           isDropdownSelected: isLoanNumberSelected,
  //           toggles: toggles,
  //         ),
  //       );
  //       showButtonBloc.add(
  //         ShowButtonEvent(
  //             show: isRequestTypeSelected &&
  //                 isRemarkValid &&
  //                 isLoanNumberSelected),
  //       );
  //     },
  //   );
  // }

  // Widget buildDropdownDepositsNumber(
  //     BuildContext context, DropdownSelectedState state) {
  //   final DropdownSelectedBloc dropdownSelectedBloc =
  //       context.read<DropdownSelectedBloc>();
  //   final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
  //   return CustomDropDown(
  //     title: "Select from the list",
  //     items: depositAccountNumbers,
  //     value: selectedDepositNumber,
  //     onChanged: (value) {
  //       toggles++;
  //       isDepositNumberSelected = true;
  //       selectedDepositNumber = value as String;
  //       dropdownSelectedBloc.add(
  //         DropdownSelectedEvent(
  //           isDropdownSelected: isDepositNumberSelected,
  //           toggles: toggles,
  //         ),
  //       );
  //       showButtonBloc.add(
  //         ShowButtonEvent(
  //             show: isRequestTypeSelected &&
  //                 isRemarkValid &&
  //                 isDepositNumberSelected),
  //       );
  //     },
  //   );
  // }

  // Widget buildDropdownAccountNumber(
  //     BuildContext context, DropdownSelectedState state) {
  //   final DropdownSelectedBloc dropdownSelectedBloc =
  //       context.read<DropdownSelectedBloc>();
  //   final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
  //   return CustomDropDown(
  //     title: "Select from the list",
  //     items: accountNumbers,
  //     value: selectedAccountNumber,
  //     onChanged: (value) {
  //       toggles++;
  //       isAccountNumberSelected = true;
  //       selectedAccountNumber = value as String;
  //       log("isAccountNumberSelected -> $isAccountNumberSelected");
  //       dropdownSelectedBloc.add(
  //         DropdownSelectedEvent(
  //           isDropdownSelected: isAccountNumberSelected,
  //           toggles: toggles,
  //         ),
  //       );
  //       showButtonBloc.add(
  //         ShowButtonEvent(
  //             show: isRequestTypeSelected &&
  //                 isRemarkValid &&
  //                 isAccountNumberSelected),
  //       );
  //     },
  //   );
  // }

  Widget buildRemarks(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomTextField(
      controller: _remarkController,
      hintText: "Type Your Remarks Here",
      bottomPadding: (16 / Dimensions.designWidth).w,
      minLines: 3,
      maxLines: 5,
      maxLength: 200,
      onChanged: (p0) {
        if (p0.isNotEmpty) {
          isRemarkValid = true;
        } else {
          isRemarkValid = false;
        }
        showButtonBloc.add(
          ShowButtonEvent(
              show: isRequestTypeSelected &&
                  isRemarkValid &&
                  isLoanNumberSelected),
        );
      },
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isRequestTypeSelected && isRemarkValid
        // &&
        // (selectedRequestIndex == 1 || selectedRequestIndex == 2
        //     ? isLoanNumberSelected
        //     : selectedRequestIndex == 3
        //         ? isDepositNumberSelected
        //         : selectedRequestIndex == 4
        //             ? isAccountNumberSelected
        //             : true)
        ) {
      return Column(
        children: [
          GradientButton(
            onTap: () async {
              if (!isRequesting) {
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                isRequesting = true;
                showButtonBloc.add(ShowButtonEvent(show: isRequesting));

                log("Create SR API Request -> ${{
                  "requestType": selectedRequest,
                  "additionalInformation":
                      selectedRequestIndex == 1 || selectedRequestIndex == 2
                          ? selectedLoanNumber
                          : selectedRequestIndex == 3
                              ? selectedDepositNumber
                              : selectedRequestIndex == 4
                                  ? selectedAccountNumber
                                  : "",
                  "remark": _remarkController.text,
                }}");

                var sRApiResult =
                    await MapCreateServiceRequest.mapCreateServiceRequest(
                  {
                    "requestType": selectedRequest,
                    "additionalInformation":
                        selectedRequestIndex == 1 || selectedRequestIndex == 2
                            ? selectedLoanNumber
                            : selectedRequestIndex == 3
                                ? selectedDepositNumber
                                : selectedRequestIndex == 4
                                    ? selectedAccountNumber
                                    : "",
                    "remark": _remarkController.text,
                  },
                  token ?? "",
                );
                log("Select Request API response -> $sRApiResult");

                if (sRApiResult["success"]) {
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      Routes.errorSuccessScreen,
                      arguments: ErrorArgumentModel(
                        hasSecondaryButton: false,
                        iconPath: ImageConstants.checkCircleOutlined,
                        title: messages[91]["messageText"],
                        message:
                            "${messages[48]["messageText"]} ${sRApiResult["serviceId"]}",
                        buttonText: "Go Home",
                        // labels[347]["labelText"],
                        onTap: () {
                          // Navigator.pop(context);
                          // Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.retailDashboard,
                            (route) => false,
                            arguments: RetailDashboardArgumentModel(
                              imgUrl: "",
                              name: profileName ?? "",
                              isFirst:
                                  storageIsFirstLogin == true ? false : false,
                            ).toMap(),
                          );
                        },
                        buttonTextSecondary: "",
                        onTapSecondary: () {},
                      ).toMap(),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Unable to Create Request",
                          message:
                              "Due to a technical problem, we are unable to create your service request. Please try again later",
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
                }

                isRequesting = false;
                showButtonBloc.add(ShowButtonEvent(show: isRequesting));
              }
            },
            text: labels[127]["labelText"],
            auxWidget: isRequesting ? const LoaderRow() : const SizeBox(),
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
          SolidButton(
            onTap: () {},
            text: labels[127]["labelText"],
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }
}
