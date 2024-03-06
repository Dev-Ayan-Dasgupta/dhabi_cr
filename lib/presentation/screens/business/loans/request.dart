// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_bloc.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_event.dart';
import 'package:dialup_mobile_app/bloc/dropdown/dropdown_selected_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/services/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:dialup_mobile_app/bloc/request/request_bloc.dart';
import 'package:dialup_mobile_app/bloc/request/request_event.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController _remarkController = TextEditingController();

  bool isRequestTypeSelected = false;
  bool isLoanSelected = false;
  bool isRemarkValid = false;

  int toggles = 0;

  String? selectedRequestType;
  String? selectedLoan;

  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    final DropdownSelectedBloc loanSelectedBloc =
        context.read<DropdownSelectedBloc>();
    loanSelectedBloc.add(DropdownSelectedEvent(
        isDropdownSelected: isLoanSelected, toggles: toggles));
    final RequestBloc requestBloc = context.read<RequestBloc>();
    requestBloc.add(RequestEvent(isEarly: false, isPartial: false));
  }

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final DropdownSelectedBloc loanSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(
        //       horizontal: (15 / Dimensions.designWidth).w,
        //       vertical: (15 / Dimensions.designWidth).w,
        //     ),
        //     child: SvgPicture.asset(ImageConstants.statement),
        //   )
        // ],
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                labels[56]["labelText"],
                                style: TextStyles.primary.copyWith(
                                  color: AppColors.dark80,
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
                              return CustomDropDown(
                                title: "Select a Request Type",
                                items: loanServiceRequest,
                                value: selectedRequestType,
                                onChanged: (value) {
                                  toggles++;
                                  isRequestTypeSelected = true;
                                  selectedRequestType = value as String;
                                  loanSelectedBloc.add(
                                    DropdownSelectedEvent(
                                      isDropdownSelected: isRequestTypeSelected,
                                      toggles: toggles,
                                    ),
                                  );
                                  showButtonBloc.add(ShowButtonEvent(
                                      show: isRequestTypeSelected));
                                },
                              );
                            },
                          ),
                          // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          //   builder: (context, state) {
                          //     if (isRequestTypeSelected) {
                          //       return Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const SizeBox(height: 20),
                          //           Text(
                          //             "Loan Number",
                          //             style: TextStyles.primary.copyWith(
                          //               color: AppColors.black63,
                          //               fontSize:
                          //                   (16 / Dimensions.designWidth).w,
                          //             ),
                          //           ),
                          //           const SizeBox(height: 10),
                          //           BlocBuilder<DropdownSelectedBloc,
                          //               DropdownSelectedState>(
                          //             builder: (context, state) {
                          //               return CustomDropDown(
                          //                 title: "Select a Loan Account",
                          //                 items: items,
                          //                 value: selectedLoan,
                          //                 onChanged: (value) {
                          //                   toggles++;
                          //                   isLoanSelected = true;
                          //                   selectedLoan = value as String;
                          //                   loanSelectedBloc.add(
                          //                     DropdownSelectedEvent(
                          //                       isDropdownSelected:
                          //                           isLoanSelected,
                          //                       toggles: toggles,
                          //                     ),
                          //                   );
                          //                   showButtonBloc.add(ShowButtonEvent(
                          //                       show: isLoanSelected));
                          //                 },
                          //               );
                          //             },
                          //           ),
                          //         ],
                          //       );
                          //     } else {
                          //       return const SizeBox();
                          //     }
                          //   },
                          // ),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizeBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        labels[58]["labelText"],
                                        style: TextStyles.primary.copyWith(
                                          color: AppColors.dark80,
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                      const Asterisk(),
                                    ],
                                  ),
                                  const SizeBox(height: 10),
                                  CustomTextField(
                                    controller: _remarkController,
                                    hintText: "Type Your Remarks Here",
                                    bottomPadding:
                                        (16 / Dimensions.designHeight).h,
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
                                        ShowButtonEvent(show: isRemarkValid),
                                      );
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                          const SizeBox(height: 20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isRemarkValid && isRequestTypeSelected) {
                      return GradientButton(
                        onTap: () async {
                          if (!isRequesting) {
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isRequesting = true;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isRequesting));

                            log("Create SR API Request -> ${{
                              "requestType": selectedRequestType,
                              "additionalInformation": "",
                              "remark": _remarkController.text,
                            }}");

                            var sRApiResult = await MapCreateServiceRequest
                                .mapCreateServiceRequest(
                              {
                                "requestType": selectedRequestType,
                                "additionalInformation": "",
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
                                    iconPath:
                                        ImageConstants.checkCircleOutlined,
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
                                        Routes.businessDashboard,
                                        (route) => false,
                                        arguments: RetailDashboardArgumentModel(
                                          imgUrl:
                                              storageProfilePhotoBase64 ?? "",
                                          name: profileName ?? "",
                                          isFirst: storageIsFirstLogin == true
                                              ? false
                                              : true,
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
                            showButtonBloc
                                .add(ShowButtonEvent(show: isRequesting));
                          }
                        },
                        text: labels[60]["labelText"],
                        auxWidget:
                            isRequesting ? const LoaderRow() : const SizeBox(),
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
                        text: labels[60]["labelText"],
                      );
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

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }
}
